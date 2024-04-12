from django.shortcuts import render,redirect
import firebase_admin
from firebase_admin import storage, auth, firestore, credentials
import pyrebase
from datetime import datetime,date

from django.core.mail import send_mail
from django.conf import settings
from django.contrib import messages
from django.http import HttpResponse
from django.http import JsonResponse

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
    if 'uid' in request.session:
        user=db.collection("tbl_user").document(request.session["uid"]).get().to_dict()
        city=db.collection("tbl_city").document(user["city_id"]).get().to_dict()
        district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()     
        return render(request,"User/UserProfile.html",{"user":user,"citydata":city,"disdata":district})
    else:
        return redirect("webguest:login")


        
    
   
    



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
    course=db.collection("tbl_course").document(id).get().to_dict()
    packagedata=db.collection("tbl_package").where("course_id","==",id).stream()
    packagelist=[]
    for i in packagedata:
        package=i.to_dict()
        packagelist.append({"package_data":package,"id":i.id})
    return render(request,"User/ViewPackages.html",{"data":packagelist,"course":course})

def viewimages(request,id):
    imagedata=db.collection("tbl_gallery").where("course_id","==",id).stream()
    imagelist=[]
    for i in imagedata:
        image=i.to_dict()
        imagelist.append({"image_data":image,"id":i.id})
    return render(request,"User/ViewImages.html",{"data":imagelist})

def viewcenter(request,id):
    uid=request.session["uid"]
    centerdata=db.collection("tbl_center").document(id).get().to_dict()
    # centerlist=[]
    # for i in centerdata:
    #     center=i.to_dict()
    #     centerlist.append({"center_data":center,"id":i.id})

    coursedata=db.collection("tbl_course").where("center_id", "==", id).stream()
    courselist=[]
    for i in coursedata:
        course=i.to_dict()
        like=getLike(i.id,uid)
        print("Like:",like)
        courselist.append({"course_data":course,"id":i.id,"like":like})
    return render(request,"User/ViewCenter.html",{"data":courselist,"center":centerdata,"cid":id})

def getLike(id,uid):
    fav=db.collection("tbl_favorites").where("course_id","==",id).where("user_id","==",uid).get()
    count=len(fav)
    if count > 0:
        return 1
    else:
        return 0

    
def ajaxlike(request):
    user_id = request.session.get("uid")
    course_id = request.GET.get("courseid")
    check_query = db.collection("tbl_favorites").where("user_id", "==", user_id).where("course_id", "==", course_id)
    check_snapshots = check_query.get()
    count = len(check_snapshots)

    if count > 0:
        for doc in check_snapshots:
            db.collection("tbl_favorites").document(doc.id).delete()
        return HttpResponse("0")  
    else:
        data = {"user_id": user_id, "course_id": course_id}
        db.collection("tbl_favorites").add(data)
        return HttpResponse("1")  







def complainttocenter(request,id):
    uid=request.session["uid"]
    
    

    compdata = db.collection("tbl_centercomplaints").where("user_id", "==", request.session["uid"]).stream()

    complist = []
    for i in compdata:
        comp = i.to_dict()
        center = getCenter(comp['center_id'])
        print('Center:',center)
        complist.append({"comp_data": comp, "id": i.id,'center':center})

        
    if request.method=="POST":
        data={"ccomplaint_title":request.POST.get("txtctitle")
            ,"ccomplaint_content":request.POST.get("txtccontent"),"user_id":uid,"center_id":id}
        db.collection("tbl_centercomplaints").add(data)
        return redirect("webuser:viewcenter", id)
    else:
        return render(request,"User/ComplaintToCenter.html",{"data":complist})

def getCenter(id):
    centerdata = db.collection("tbl_center").document(id).get().to_dict()
    if centerdata:
        center_name = centerdata.get("center_name")
        return center_name
    return ''

def bookpackage(request, id):
    bookdata = db.collection("tbl_booking").where("user_id", "==", request.session["uid"]).where("package_id", "==", id).where("booking_status","==",1).stream()

    for i in bookdata:
        packdata = db.collection("tbl_package").document(id).get().to_dict()
        if packdata:
            courseid = packdata["course_id"]
            messages.success(request, 'You have already booked for this course!')
            return redirect("webuser:viewpackages", courseid)
        else:
            return HttpResponse("Package not found")  # Handle case when no package is found for the specified ID
    
    uid = request.session["uid"]
    packagedata = db.collection("tbl_package").document(id).get().to_dict()

    if packagedata:
        packamount = packagedata.get('package_cost', 0)  # Access 'package_cost' safely
        data = {"user_id": uid, "package_id": id, "booking_date_time": datetime.now(), "booking_status": 0, "payment_amount": packamount}
        db.collection("tbl_booking").add(data)
        return redirect("webuser:payment")
    else:
        return HttpResponse("Package not found")  # Handle case when no package is found for the specified ID


def payment(request):
    print('Hi')
    bookingdata=db.collection("tbl_booking").where("user_id","==",request.session["uid"]).where("booking_status","==",0).order_by("booking_date_time", direction=firestore.Query.DESCENDING).limit(1).stream()
    bookingid = None  # Initialize bookingid to None in case no document is found
    for doc in bookingdata:
        bookingid = doc.id
        break  # Break out of the loop after getting the first document

    print(bookingid)

        
    if request.method=="POST":
        db.collection("tbl_booking").document(bookingid).update({"booking_status":1})
        return redirect("webuser:viewbookings")
    else:
        return render(request, "User/Payment.html")

def viewbookings(request):
    booklist=[]
    bookingdata=db.collection("tbl_booking").where("user_id","==",request.session["uid"]).where("booking_status","==",1).stream()
    for i in bookingdata:
        bdata=i.to_dict()
        
        pack=db.collection("tbl_package").document(bdata["package_id"]).get().to_dict()
        course=db.collection("tbl_course").document(pack["course_id"]).get().to_dict()
        center=db.collection("tbl_center").document(course["center_id"]).get().to_dict()
        
           
        booklist.append({"book":bdata,"pack":pack,"course":course,"center":center,"id":i.id})
        
    return render(request,"User/ViewBookings.html",{"booking":booklist})

def cancelbooking(request,id):
    db.collection("tbl_booking").document(id).update({"booking_status":2})
    user=db.collection("tbl_user").document(request.session["uid"]).get().to_dict()
    email=user['user_email']
    send_mail(
        'Welcome to Hobbio',
        'Dear ' + user['user_name'] + ',\n\n'
        'Your request to cancel the course booking is under processing...'
        'After the admin review, we will refund your amount shortly...'
        'Thank you for choosing Hobbio. If you have any questions or need assistance, feel free to reach out.\n\n'
        'Best regards,\n'
        'The Hobbio Team',
        settings.EMAIL_HOST_USER,
        [email],
    )     
    
    return redirect("webuser:viewbookings")

def favorites(request):
    favlist=[]
    favdata=db.collection("tbl_favorites").where("user_id","==",request.session["uid"]).stream()
    for i in favdata:
        fdata=i.to_dict()
        course=db.collection("tbl_course").document(fdata["course_id"]).get().to_dict()
        center=db.collection("tbl_center").document(course["center_id"]).get().to_dict()
        favlist.append({"course":course,"center":center,"id":i.id})
    return render(request,"User/Favorites.html",{"data":favlist})

def favdel(request,id):
    db.collection("tbl_favorites").document(id).delete()
    return redirect("webuser:favorites")

def rating(request,id):
    if 'uid' in request.session:
        parray=["1","2","3","4","5"]    
        bdata = db.collection("tbl_booking").document(id).get().to_dict()
        pdata=db.collection("tbl_package").document(bdata["package_id"]).get().to_dict()
        codata=db.collection("tbl_course").document(pdata["course_id"]).get().to_dict()
        cdata=db.collection("tbl_center").document(codata["center_id"]).get().to_dict()
        count = 0
        r_len = 0
        r_data = []
        rate = db.collection("tbl_rating").where("center_id", "==", codata["center_id"]).stream()
        for i in rate:
            rdata = i.to_dict()
            r_len = r_len + int(len(rdata))
        rlen = r_len // 5
        if rlen>0:
            res=0    
            ratedata = db.collection("tbl_rating").where("center_id", "==", codata["center_id"]).stream()
            for i in ratedata:
                rated = i.to_dict()
                r_data.append({"data":i.to_dict()})
                res = res + int(rated["rating_data"])
                avg = res//rlen
            return render(request,"User/Rating.html",{"id":id,"data":r_data,"ar":parray,"avg":avg,"count":rlen})
        else:
            return render(request,"User/Rating.html",{'id':id})
    else:
        return redirect("webguest:login")

def ajaxrating(request):
    parray=[1,2,3,4,5]
    rate_data = []
    bdata = db.collection("tbl_booking").document(request.GET.get('workid')).get().to_dict()
    pdata=db.collection("tbl_package").document(bdata["package_id"]).get().to_dict()
    codata=db.collection("tbl_course").document(pdata["course_id"]).get().to_dict()
    cdata=db.collection("tbl_center").document(codata["center_id"]).get().to_dict()
    datedata = date.today()
    db.collection("tbl_rating").add({"rating_data":request.GET.get('rating_data'),"user_name":request.GET.get('user_name'),"user_review":request.GET.get('user_review'),"center_id":codata["center_id"],"date":str(datedata)})
    pdt = db.collection("tbl_rating").where("center_id", "==", codata["center_id"]).stream()
    for p in pdt:
        rate_data.append({"rate":p.to_dict(),"id":p.id})
    return render(request,"User/AjaxRating.html",{'data':rate_data,'ar':parray})

def starrating(request):
    r_len = 0
    five = four = three = two = one = 0
    bdata = db.collection("tbl_booking").document(request.GET.get("pdt")).get().to_dict()
    pdata=db.collection("tbl_package").document(bdata["package_id"]).get().to_dict()
    codata=db.collection("tbl_course").document(pdata["course_id"]).get().to_dict()
    cdata=db.collection("tbl_center").document(codata["center_id"]).get().to_dict()
    rate = db.collection("tbl_rating").where("center_id", "==", codata["center_id"]).stream()
    for i in rate:
        rated = i.to_dict()
        if int(rated["rating_data"]) == 5:
            five = five + 1
        elif int(rated["rating_data"]) == 4:
            four = four + 1
        elif int(rated["rating_data"]) == 3:
            three = three + 1
        elif int(rated["rating_data"]) == 2:
            two = two + 1
        elif int(rated["rating_data"]) == 1:
            one = one + 1
        else:
            five = four = three = two = one = 0
        r_len = r_len + int(len(rated))
    rlen = r_len // 5
    result = {"five":five,"four":four,"three":three,"two":two,"one":one,"total_review":rlen}
    return JsonResponse(result)

def logout(request):
    del request.session["uid"]
    return redirect("webguest:login")








    
    

