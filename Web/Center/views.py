from django.shortcuts import render,redirect
import firebase_admin
from firebase_admin import storage,auth,firestore,credentials
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
def CenterHome(request):
    center=db.collection("tbl_center").document(request.session["cid"]).get().to_dict()
    return render(request,"Center/CenterHome.html",{"center":center})


def CenterProfile(request):
    if 'cid' in request.session:
        center=db.collection("tbl_center").document(request.session["cid"]).get().to_dict()
        city=db.collection("tbl_city").document(center["city_id"]).get().to_dict()
        district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()
        # citylist.append("city":city,"district":district)
        return render(request,"Center/CenterProfile.html",{"center":center,"citydata":city,"disdata":district})
    else:
        return redirect("webguest:login")
        
    


def CenterEditProfile(request):
    center=db.collection("tbl_center").document(request.session["cid"]).get().to_dict()
    city=db.collection("tbl_city").document(center["city_id"]).get().to_dict()
    district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()

    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})

    if request.method=="POST":        
        logo = request.FILES.get("txtlogo")
        if logo:
            path = "Center_Logo/" + logo.name
            sd.child(path).put(logo)
            d_url = sd.child(path).get_url(None)
            db.collection("tbl_center").document(request.session["cid"]).update({"center_logo":d_url})
            

        db.collection("tbl_center").document(request.session["cid"]).update({"center_name":request.POST.get("txtcname"),
        "center_contact":request.POST.get("txtccontact"),
        "center_building":request.POST.get("txtcbuilding"),"center_area":request.POST.get("txtcarea"),
        "center_landmark":request.POST.get("txtclandmark"),"center_type":request.POST.get("seltype"),
        "city_id":request.POST.get("selcity")})
        return redirect("webcenter:centerprofile")
    else:
        return render(request,"Center/CenterEditProfile.html",{"center":center,"disdata":dislist,"citydata":city})

def CenterChangePassword(request):

    center = db.collection("tbl_center").document(request.session["cid"]).get().to_dict()
    email = center["center_email"]
        # print(email)
    em_link = firebase_admin.auth.generate_password_reset_link(email)
    send_mail(
            'Reset your password ', #subject
            "\rHello \r\nFollow this link to reset your Project password for your " + email + "\n" + em_link +".\n If you didn't ask to reset your password, you can ignore this email. \r\n Thanks. \r\n Your Hobbio team.",#body
            settings.EMAIL_HOST_USER,
            [email],
    )
    return redirect("webcenter:centerprofile")

def centeraddcourse(request):
    id=request.session["cid"]
    catdata=db.collection("tbl_category").stream()
    catlist=[]
    for i in catdata:
        cat=i.to_dict()
        catlist.append({"cat_data":cat,"id":i.id})
    
    coursedata=db.collection("tbl_course").where("center_id","==",id).stream()
    courselist=[]
    for i in coursedata:
        course=i.to_dict()
        subcategory=db.collection("tbl_subcategory").document(course["subcategory_id"]).get().to_dict()
        category=db.collection("tbl_category").document(subcategory["category_id"]).get().to_dict()
        courselist.append({"course_data":course,"id":i.id,"category":category,"subcategory":subcategory, "course_name":course})

    if request.method=="POST":
        data={"course_name":request.POST.get("txtcoursename"),"course_des":request.POST.get("txtcoursedes"),
        "subcategory_id":request.POST.get("selsubcategory"),"center_id":id}
        db.collection("tbl_course").add(data)
        return redirect("webcenter:centeraddcourse")
    else:
        return render(request,"Center/CenterAddCourse.html",{"data":catlist,"course":courselist})

def delete_course(request,id):
    db.collection("tbl_course").document(id).delete()
    return redirect("webcenter:centeraddcourse")



def ajaxsubcategory(request):
    subcat = db.collection("tbl_subcategory").where("category_id", "==", request.GET.get("did")).stream()
    subcat_data = []
    for c in subcat:
        subcat_data.append({"subcat":c.to_dict(),"id":c.id})
    return render(request,"Center/AjaxSubCategory.html",{"subcat":subcat_data})

def centeraddpackage(request,id):
    request.session["coid"]=id
    packdata=db.collection("tbl_package").where("course_id","==",request.session["coid"]).stream()
    packlist=[]
    for i in packdata:
        pack=i.to_dict()
        course=db.collection("tbl_course").document(pack["course_id"]).get().to_dict()
        packlist.append({"pack_data":pack,"id":i.id,"course_name":course})
    
    
    if request.method =="POST":
        data={"package_name":request.POST.get("txtpackname"),"package_duration":request.POST.get("txtpackduration"),
        "package_cost":request.POST.get("txtpackcost"),"package_details":request.POST.get("txtpackdetails"),
        "course_id":id}
        db.collection("tbl_package").add(data)
        return render(request,"Center/CenterAddPackage.html",{"id":id,'msg':'Package added successfully'})
    else:
        return render(request,"Center/CenterAddPackage.html",{"data":packlist})

def centeraddimage(request,id):
    request.session["coid"]=id
    imagedata=db.collection("tbl_gallery").where("course_id","==",request.session["coid"]).stream()
    imagelist=[]
    for i in imagedata:
        images= i.to_dict()
        imagelist.append({"image_data":images,"id":i.id})
    if request.method == "POST":
        image = request.FILES.get("txtimage")
        if image:
            path = "Center_Gallery/" + image.name
            sd.child(path).put(image)
            d_url = sd.child(path).get_url(None)
        data={"gallery_image":d_url,"course_id":id}
        db.collection("tbl_gallery").add(data)
        return render(request,"Center/CenterAddImage.html",{"id":id,'msg':'Image added successfully'})
    else:
        return render(request,"Center/CenterAddImage.html",{"data":imagelist})

def delete_image(request,id):
    db.collection("tbl_gallery").document(id).delete()
    messages.success(request,'Image Deleted Successfully...')
    return redirect("webcenter:centeraddimage",id)



def delete_package(request,id):
    db.collection("tbl_package").document(id).delete()
    messages.success(request,'Package Deleted Successfully...')
    return redirect("webcenter:centeraddpackage",id)

def edit_package(request,id):
    coid=request.session["coid"]
    pack = db.collection("tbl_package").document(id).get().to_dict()
    if request.method =="POST":
        db.collection("tbl_package").document(id).update({"package_name":request.POST.get("txtpackname")
        ,"package_cost":request.POST.get("txtpackcost"),"package_duration":request.POST.get("txtpackduration"),
        "package_details":request.POST.get("txtpackdetails")})
        return render(request,"Center/CenterAddPackage.html",{"id":coid,'msg':'Package Updated'})
    else:
        return render( request,"Center/CenterAddPackage.html",{ "pack":pack } )

def centercomplaint(request):
    id=request.session["cid"]

    compdata=db.collection("tbl_complaints").where("center_id", "==", request.session["cid"]).stream()
    complist=[]
    for i in compdata:
        comp=i.to_dict()
        complist.append({"comp_data":comp,"id":i.id})
        
    if request.method=="POST":
        data={"complaint_title":request.POST.get("txtctitle")
            ,"complaint_content":request.POST.get("txtccontent"),"center_id":id,"user_id":0}
        db.collection("tbl_complaints").add(data)
        return redirect("webcenter:centercomplaint")
    else:
        return render(request,"Center/CenterComplaints.html",{"data":complist})

def centerfeedback(request):
    id=request.session["cid"]
    if request.method=="POST":
        data={"feedback_content":request.POST.get("txtfcontent")
            ,"center_id":id,"user_id":0,"feedback_time":datetime.now()}
        db.collection("tbl_feedbacks").add(data)
        return redirect("webcenter:centerfeedback")
    else:
        return render(request,"Center/CenterFeedback.html")

def viewcomplaints(request):
    id=request.session["cid"]

    ccompdata = db.collection("tbl_centercomplaints").where("center_id", "==", id).stream()
    ccomplist2 = []
    for i in ccompdata:
        comp = i.to_dict()
        if comp["user_id"] != 0:
            user = db.collection("tbl_user").document(comp["user_id"]).get().to_dict()
            ccomplist2.append({"ccomp_data": comp, "id": i.id, "user": user})
    return render(request,"Center/ViewComplaints.html",{"data2":ccomplist2})

def replycomplaints(request,id):
    if request.method=="POST":
        db.collection("tbl_centercomplaints").document(id).update({"ccomplaint_reply":request.POST.get("txtreply")})
        return redirect("webcenter:viewcomplaints")
    else:
        return render(request,"Center/ReplyComplaints.html")

def viewbookings(request):
    booklist = []   
    bkids = [] 
    coursedata = db.collection("tbl_course").where("center_id", "==", request.session.get("cid")).stream()      
    for course in coursedata:          
        course_data = course.to_dict()                
        packagedata = db.collection("tbl_package").where("course_id", "==", course.id).stream()            
        for package in packagedata:               
            package_data = package.to_dict() 
            bookdata = db.collection("tbl_booking").where("package_id", "==", package.id).where("booking_status","==",1).stream()    
            for i in bookdata:    
                bkids.append(i.id)  
    # print(bkids)  
    for bk in bkids:
          bookdata = db.collection("tbl_booking").document(bk).get().to_dict()
          user = db.collection("tbl_user").document(bookdata["user_id"]).get().to_dict()
          package = db.collection("tbl_package").document(bookdata["package_id"]).get().to_dict()
          course=db.collection("tbl_course").document(package["course_id"]).get().to_dict()
          booklist.append({"book":bookdata,"user":user,"package":package,"course":course})
            # bookdata = getBook(package.id)
            # if bookdata:  # Check if bookdata is not empty
            #     booklist.append({"course": course_data, "pack": package_data, "user": bookdata[0]})
            # else:
            #     # Handle the case where no booking data is available for this package
            #     booklist.append({"course": course_data, "pack": package_data, "user": None})
            #     print(booklist)
                
                                 
    return render(request, "Center/ViewBookings.html",{"data":booklist})



# def getBook(id):
#     booking_list = []  
#     booking_list2 = []  
#     bookdata = db.collection("tbl_booking").where("package_id", "==", id).where("booking_status","==",1).stream()    
#     for i in bookdata:
#         bdata = i.to_dict()                     
#         userdata = db.collection("tbl_user").document(bdata["user_id"]).get().to_dict()      
                
#         # booking_list.append({"booking": bdata, "user": userdata}) 
#         booking_list2.append({**bdata,**userdata}) 
#         # print("output:",booking_list)
#         # print("output2:",booking_list2)
         
#     return booking_list2

def viewratings(request):
    ratelist=[]
    ratedata=db.collection("tbl_rating").where("center_id","==",request.session["cid"]).stream()
    for i in ratedata:
        rate=i.to_dict()
        ratelist.append({"rate":rate})
    return render(request,"Center/ViewRating.html",{"data":ratelist})

def logout(request):
    del request.session["cid"]
    return redirect("webguest:login")

