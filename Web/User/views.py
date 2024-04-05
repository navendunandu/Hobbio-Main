from django.shortcuts import render,redirect
import firebase_admin
from firebase_admin import storage, auth, firestore, credentials
import pyrebase
from datetime import datetime

from django.core.mail import send_mail
from django.conf import settings
from django.contrib import messages

db=firestore.client()

config = {
  "apiKey": "AIzaSyA4iNjcb390KJOi25VaGVsTCM1djA4zXD8",
  "authDomain": "hobbio-6b939.firebaseapp.com",
  "projectId": "hobbio-6b939",
  "storageBucket": "hobbio-6b939.appspot.com",
  "messagingSenderId": "104141305158",
  "appId": "1:104141305158:web:16755bef131a8c2acba147",
  "measurementId": "G-M176GP825J",
  "databaseURL" : ""
}

firebase = pyrebase.initialize_app(config)
sd = firebase.storage()
authe = firebase.auth()


# Create your views here.

def UserHome(request):
    user=db.collection("tbl_user").document(request.session["uid"]).get().to_dict()
    return render(request,"User/UserHome.html",{"user":user})

def UserProfile(request):
    user=db.collection("tbl_user").document(request.session["uid"]).get().to_dict()
    # print(user)
    # citylist=[]
    city=db.collection("tbl_city").document(user["city_id"]).get().to_dict()
    district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()
    # citylist.append("city":city,"district":district)
    return render(request,"User/UserProfile.html",{"user":user,"citydata":city,"disdata":district})

def UserEditProfile(request):
    user=db.collection("tbl_user").document(request.session["uid"]).get().to_dict()
    city=db.collection("tbl_city").document(user["city_id"]).get().to_dict()
    district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()

    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})

    if request.method=="POST":        
        photo = request.FILES.get("txtphoto")
        if photo:
            path = "User_Photo/" + photo.name
            sd.child(path).put(photo)
            d_url = sd.child(path).get_url(None)
            db.collection("tbl_user").document(request.session["uid"]).update({"user_photo":d_url})
            

        db.collection("tbl_user").document(request.session["uid"]).update({"user_name":request.POST.get("txtname"),
        "user_contact":request.POST.get("txtcontact"),"user_dob":request.POST.get("txtdob"),
        "user_housename":request.POST.get("txthousename"),"user_area":request.POST.get("txtarea"),
        "city_id":request.POST.get("selcity")})
        return redirect("webuser:userprofile")
    else:
        return render(request,"User/UserEditProfile.html",{"user":user,"disdata":dislist,"citydata":city})

def UserChangePassword(request):

    user = db.collection("tbl_user").document(request.session["uid"]).get().to_dict()
    email = user["user_email"]
        # print(email)
    em_link = firebase_admin.auth.generate_password_reset_link(email)
    send_mail(
            'Reset your password ', #subject
            "\rHello \r\nFollow this link to reset your Project password for your " + email + "\n" + em_link +".\n If you didn't ask to reset your password, you can ignore this email. \r\n Thanks. \r\n Your Hobbio team.",#body
            settings.EMAIL_HOST_USER,
            [email],
    )
    return redirect("webuser:userprofile")
    

def usercomplaint(request):
    id=request.session["uid"]

    compdata=db.collection("tbl_complaints").where("user_id", "==", request.session["uid"]).stream()
    complist=[]
    for i in compdata:
        comp=i.to_dict()
        complist.append({"comp_data":comp,"id":i.id})
        
    if request.method=="POST":
        data={"complaint_title":request.POST.get("txtctitle")
            ,"complaint_content":request.POST.get("txtccontent"),"user_id":id,"center_id":0}
        db.collection("tbl_complaints").add(data)
        return redirect("webuser:usercomplaint")
    else:
        return render(request,"User/UserComplaints.html",{"data":complist})

def userfeedback(request):
    id=request.session["uid"]
    if request.method=="POST":
        data={"feedback_content":request.POST.get("txtfcontent")
            ,"user_id":id,"center_id":0,"feedback_time":datetime.now()}
        db.collection("tbl_feedbacks").add(data)
        return redirect("webuser:userfeedback")
    else:
        return render(request,"User/UserFeedback.html")

def searchcenters(request):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})

    catdata=db.collection("tbl_category").stream()
    catlist=[]
    for i in catdata:
        cat=i.to_dict()
        catlist.append({"cat_data":cat,"id":i.id})
    center = db.collection("tbl_center").where("center_status", "==", 1).stream()
    center_data = []
    for c in center:
        center_data.append({"data":c.to_dict(),"id":c.id})
    return render(request,"User/SearchCenters.html",{"district":dislist,"category":catlist,"center":center_data})


def ajaxcenter(request):
    if request.GET.get("cid") != "":
        center = db.collection("tbl_center").where("city_id", "==", request.GET.get("cid")).where("center_status", "==", 1).stream()
        c_data = []
        for c in center:
            c_data.append({"data":c.to_dict(),"id":c.id})
        return render(request,"User/AjaxCenter.html",{"data":c_data})
    elif request.GET.get("did") != "":
        city = db.collection("tbl_city").where("district_id", "==", request.GET.get("did")).stream()
        c_data = []
        for c in city:
            center = db.collection("tbl_center").where("city_id", "==", c.id).where("center_status", "==", 1).stream()
            for c in center:
                c_data.append({"data":c.to_dict(),"id":c.id})
        return render(request,"User/AjaxCenter.html",{"data":c_data})
    # elif request.GET.get("sid") != "":
    #     course = db.collection("tbl_course").where("subcategory_id", "==", request.GET.get("sid")).stream()
    #     c_data = []
    #     for c in course:
    #         datas = c.to_dict()
    #         center = db.collection("tbl_center").document(datas["center_id"]).get().to_dict()
    #         cen = db.collection("tbl_center").document(datas["center_id"]).get()
    #         c_data.append({"data":center,"id":cen.id})
    #     return render(request,"User/AjaxCenter.html",{"data":c_data})
    # elif request.GET.get("caid") != "":
    #     sub = db.collection("tbl_subcategory").where("category_id", "==", request.GET.get("caid")).stream()
    #     c_data = []
    #     for su in sub:
    #         course = db.collection("tbl_course").where("subcategory_id", "==", su.id).stream()
    #         for c in course:
    #             datas = c.to_dict()
    #             center = db.collection("tbl_center").document(datas["center_id"]).get().to_dict()
    #             cen = db.collection("tbl_center").document(datas["center_id"]).get()
    #             c_data.append({"data":center,"id":cen.id})
    #     return render(request,"User/AjaxCenter.html",{"data":c_data})


def viewpackages(request,id):
    packagedata=db.collection("tbl_package").where("course_id","==",id).stream()
    packagelist=[]
    for i in packagedata:
        package=i.to_dict()
        packagelist.append({"package_data":package,"id":i.id})
    return render(request,"User/ViewPackages.html",{"data":packagelist})

def viewimages(request,id):
    imagedata=db.collection("tbl_gallery").where("course_id","==",id).stream()
    imagelist=[]
    for i in imagedata:
        image=i.to_dict()
        imagelist.append({"image_data":image,"id":i.id})
    return render(request,"User/ViewImages.html",{"data":imagelist})

def viewcenter(request,id):
    centerdata=db.collection("tbl_center").where("center_id","==",id).stream()
    centerlist=[]
    for i in centerdata:
        center=i.to_dict()
        centerlist.append({"center_data":center,"id":i.id})
    coursedata=db.collection("tbl_course").where("center_id", "==", id).stream()
    courselist=[]
    for i in coursedata:
        course=i.to_dict()
        courselist.append({"course_data":course,"id":i.id})
    return render(request,"User/ViewCenter.html",{"data":courselist,"center":centerlist})



def complainttocenter(request,id):
    uid=request.session["uid"]

    compdata=db.collection("tbl_centercomplaints").where("user_id", "==", request.session["uid"]).stream()
    complist=[]
    for i in compdata:
        comp=i.to_dict()
        complist.append({"comp_data":comp,"id":i.id})
        
    if request.method=="POST":
        data={"ccomplaint_title":request.POST.get("txtctitle")
            ,"ccomplaint_content":request.POST.get("txtccontent"),"user_id":uid,"center_id":id}
        db.collection("tbl_centercomplaints").add(data)
        return redirect("webuser:complainttocenter")
    else:
        return render(request,"User/ComplaintToCenter.html",{"data":complist})
