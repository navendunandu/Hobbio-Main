from django.shortcuts import render,redirect
import firebase_admin
from firebase_admin import storage,auth,firestore,credentials
import pyrebase
import json
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

def AdminRegistration(request):
    if request.method == "POST":
        email=request.POST.get("txtemail")
        password=request.POST.get("txtpassword")
        try:
            admin=firebase_admin.auth.create_user(email=email,password=password)
        except(firebase_admin._auth_utils.EmailAlreadyExistsError,ValueError) as error:
            return render(request,"Admin/AdminRegistration.html",{"msg":error})

        data={"admin_name":request.POST.get("txtname"),"admin_contact":request.POST.get("txtcontact"),
        "admin_email":request.POST.get("txtemail"),"admin_id":admin.uid}
        db.collection("tbl_admin").add(data)
        return render(request,"Admin/AdminRegistration.html")
    else:
        return render(request,"Admin/AdminRegistration.html")

def AdminHome(request):
    admin=db.collection("tbl_admin").document(request.session["aid"]).get().to_dict()
    catdata=dashcategoryreport()
    xcat=[]
    ycat=[]
    for cat in catdata:
        xcat.append(cat['catname'])
        ycat.append(cat['count'])
    xcatjson = json.dumps(xcat)
    ycatjson = json.dumps(ycat)

    ldata=dashlearnersreport()
    xl=[]
    yl=[]
    for l in ldata:
        xl.append(l['center'])
        yl.append(l['count'])
    xljson = json.dumps(xl)
    yljson = json.dumps(yl) 

    scatdata=dashsubcategoryreport()
    xs=[]
    ys=[]
    for s in scatdata:
        xs.append(s['scatname'])
        ys.append(s['count'])  
    xsjson = json.dumps(xs)
    ysjson = json.dumps(ys)  
    return render(request,"Admin/AdminHome.html",{"admin":admin,'xcat':xcatjson,'ycat':ycatjson,'xl':xljson,'yl':yljson
                                                  ,'xs':xsjson,'ys':ysjson})


def District(request):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})
    if request.method=="POST":
        data={"district_name":request.POST.get("txtdistrict")}
        db.collection("tbl_district").add(data)
        return redirect("webadmin:district")
    else:
        return render(request,"Admin/District.html",{"data":dislist})


def delete_dis(request,id):
    db.collection("tbl_district").document(id).delete()
    return redirect("webadmin:district")

def edit_dis(request,id):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})
    dis = db.collection("tbl_district").document(id).get().to_dict()
    if request.method =="POST":
        db.collection("tbl_district").document(id).update({"district_name":request.POST.get("txtdistrict")})
        return redirect("webadmin:district")
    else:
        return render(request,"Admin/District.html",{'dis':dis,"data":dislist})
        

def City(request):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})

    citydata=db.collection("tbl_city").stream()
    citylist=[]
    for i in citydata:
        
        city=i.to_dict()
        district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()
        citylist.append({"city_data":city,"id":i.id,"dis_name":district})

    if request.method=="POST":
        data={"city_name":request.POST.get("txtcity"),"district_id":request.POST.get("seldistrict")}
        db.collection("tbl_city").add(data)
        return redirect("webadmin:city")
    else:
        return render(request,"Admin/City.html",{"data":dislist,"city":citylist})




def delete_city(request,id):
    db.collection("tbl_city").document(id).delete()
    return redirect("webadmin:city")

def edit_city(request,id):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})
    city=db.collection("tbl_city").document(id).get().to_dict()
    district=db.collection("tbl_district").document(city['district_id']).get().to_dict()
    
    if request.method == "POST":
        db.collection("tbl_city").document(id).update({"city_name":request.POST.get("txtcity"),
        "district_id":request.POST.get("seldistrict")})
        return redirect("webadmin:city")
    else:
        return render(request,"Admin/City.html",{'city_data':city,'district':district,'data':dislist})





def Category(request):
    catdata=db.collection("tbl_category").stream()
    catlist=[]
    for i in catdata:
        cat=i.to_dict()
        catlist.append({"cat_data":cat,"id":i.id})
    if request.method=="POST":
        data={"category_name":request.POST.get("txtcategory")}
        db.collection("tbl_category").add(data)
        return redirect("webadmin:category")
    else:
        return render(request,"Admin/Category.html",{"data":catlist})


def delete_cat(request,id):
    db.collection("tbl_category").document(id).delete()
    return redirect("webadmin:category")

def edit_cat(request,id):
    catdata=db.collection("tbl_category").stream()
    catlist=[]
    for i in catdata:
        cat=i.to_dict()
        catlist.append({"cat_data":cat,"id":i.id})
    cat = db.collection("tbl_category").document(id).get().to_dict()
    if request.method =="POST":
        db.collection("tbl_category").document(id).update({"category_name":request.POST.get("txtcategory")})
        return redirect("webadmin:category")
    else:
        return render(request,"Admin/Category.html",{'cat':cat,"data":catlist})


def SubCategory(request):
    catdata=db.collection("tbl_category").stream()
    catlist=[]
    for i in catdata:
        cat=i.to_dict()
        catlist.append({"cat_data":cat,"id":i.id})

    subcatdata=db.collection("tbl_subcategory").stream()
    subcatlist=[]
    for i in subcatdata:
        subcat=i.to_dict()
        category=db.collection("tbl_category").document(subcat["category_id"]).get().to_dict()
        subcatlist.append({"subcat_data":subcat,"id":i.id,"cat_name":category})

    if request.method=="POST":
        data={"subcategory_name":request.POST.get("txtsubcat"),"category_id":request.POST.get("selcategory")}
        db.collection("tbl_subcategory").add(data)
        return redirect("webadmin:subcategory")
    else:
        return render(request,"Admin/SubCategory.html",{"data":catlist,"subcat":subcatlist})

def delete_subcat(request,id):
    db.collection("tbl_subcategory").document(id).delete()
    return redirect("webadmin:subcategory")
        
def edit_subcat(request,id):
    catdata=db.collection("tbl_category").stream()
    catlist=[]
    for i in catdata:
        cat=i.to_dict()
        catlist.append({"cat_data":cat,"id":i.id})
    subcat=db.collection("tbl_subcategory").document(id).get().to_dict()
    category=db.collection("tbl_category").document(subcat['category_id']).get().to_dict()

    if request.method=="POST":
        db.collection("tbl_subcategory").document(id).update({"subcategory_name":request.POST.get("txtsubcat"),"category_id":request.POST.get("selcategory")})
        return redirect("webadmin:subcategory")
    else:
        return render(request,"Admin/SubCategory.html",{'subcat_data':subcat,'category':category,'data':catlist})

def centerverification(request):
    centerdata=db.collection("tbl_center").where("center_status", "==", 0).stream()
    centerlist=[]
    for i in centerdata:
        center=i.to_dict()
        centerlist.append({"center_data":center,"id":i.id})
        
    centerdata=db.collection("tbl_center").where("center_status", "==", 1).stream()
    centerlist2=[]
    for i in centerdata:
        center=i.to_dict()
        centerlist2.append({"center_data":center,"id":i.id})

    centerdata=db.collection("tbl_center").where("center_status", "==", 2).stream()
    centerlist3=[]
    for i in centerdata:
        center=i.to_dict()
        centerlist3.append({"center_data":center,"id":i.id})
    
    return render(request,"Admin/CenterVerification.html",{'data':centerlist,"data2":centerlist2,"data3":centerlist3})



def center_accept(request,id):
    db.collection("tbl_center").document(id).update({"center_status":1})
    center=db.collection("tbl_center").document(id).get().to_dict()
    email=center['center_email']
    send_mail(
        'Welcome to Hobbio',
        'Dear ' + center['center_name'] + ',\n\n'
        'We are excited to welcome you to Hobbio.'
        'Thank you for choosing Hobbio. If you have any questions or need assistance, feel free to reach out.\n\n'
        'Best regards,\n'
        'The Hobbio Team',
        settings.EMAIL_HOST_USER,
        [email],
    )     
    
    return redirect("webadmin:centerverification")

def center_reject(request,id):
    db.collection("tbl_center").document(id).update({"center_status":2})
    return redirect("webadmin:centerverification")

def center_viewmore(request,id):
    center = db.collection("tbl_center").document(id).get().to_dict()
    city=db.collection("tbl_city").document(center["city_id"]).get().to_dict()
    district=db.collection("tbl_district").document(city["district_id"]).get().to_dict()
    return render( request,"Admin/CenterViewMore.html",{ "center":center ,"city":city,"district":district} )

def viewcomplaints(request):
    ccompdata=db.collection("tbl_complaints").where("center_id","!=",0).stream()
    ccomplist=[]
    for i in ccompdata:
        comp=i.to_dict()
        center=db.collection("tbl_center").document(comp["center_id"]).get().to_dict()
        ccomplist.append({"ccomp_data":comp,"id":i.id,"center":center})

    ccompdata=db.collection("tbl_complaints").where("user_id","!=",0).stream()
    ccomplist2=[]
    for i in ccompdata:
        comp=i.to_dict()
        user=db.collection("tbl_user").document(comp["user_id"]).get().to_dict()
        ccomplist2.append({"ccomp_data":comp,"id":i.id,"user":user})
    return render(request,"Admin/ViewComplaints.html",{"data":ccomplist,"data2":ccomplist2})

def replycomplaints(request,id):
    if request.method=="POST":
        db.collection("tbl_complaints").document(id).update({"complaint_reply":request.POST.get("txtreply")})
        return redirect("webadmin:viewcomplaints")
    else:
        return render(request,"Admin/ReplyComplaints.html")

def viewfeedbacks(request):
    feeddata=db.collection("tbl_feedbacks").where("center_id","!=",0).stream()
    feedlist1=[]
    for i in feeddata:
        feed=i.to_dict()
        center=db.collection("tbl_center").document(feed["center_id"]).get().to_dict()
        feedlist1.append({"cfeed_data":feed,"id":i.id,"center":center})

    feeddata=db.collection("tbl_feedbacks").where("user_id","!=",0).stream()
    feedlist2=[]
    for i in feeddata:
        feed=i.to_dict()
        user=db.collection("tbl_user").document(feed["user_id"]).get().to_dict()
        feedlist2.append({"ufeed_data":feed,"id":i.id,"user":user})
    return render(request,"Admin/ViewFeedbacks.html",{"data":feedlist1,"data2":feedlist2})

def viewbookings(request):
    booklist=[]
    bookingdata=db.collection("tbl_booking").where("booking_status","==",1).stream()
    for i in bookingdata:
        bdata=i.to_dict()
        user=db.collection("tbl_user").document(bdata["user_id"]).get().to_dict()
        pack=db.collection("tbl_package").document(bdata["package_id"]).get().to_dict()
        course=db.collection("tbl_course").document(pack["course_id"]).get().to_dict()
        center=db.collection("tbl_center").document(course["center_id"]).get().to_dict()
        
           
        booklist.append({"book":bdata,"pack":pack,"course":course,"center":center,"user":user})
        
    return render(request,"Admin/ViewBookings.html",{"booking":booklist})

def cancelledbookings(request):
    booklist=[]
    bookingdata=db.collection("tbl_booking").where("booking_status","==",2).stream()
    for i in bookingdata:
        bdata=i.to_dict()
        user=db.collection("tbl_user").document(bdata["user_id"]).get().to_dict()
        pack=db.collection("tbl_package").document(bdata["package_id"]).get().to_dict()
        course=db.collection("tbl_course").document(pack["course_id"]).get().to_dict()
        center=db.collection("tbl_center").document(course["center_id"]).get().to_dict()
        
           
        booklist.append({"book":bdata,"pack":pack,"course":course,"center":center,"user":user,"id":i.id})
        
    return render(request,"Admin/CancelledBooking.html",{"booking":booklist})

def send(request,id):
    db.collection("tbl_booking").document(id).update({"booking_status":3})
    book=db.collection("tbl_booking").document(id).get().to_dict()
    user=db.collection("tbl_user").document(book["user_id"]).get().to_dict()
    email=user['user_email']
    send_mail(
        'Welcome to Hobbio',
        'Dear ' + user['user_name'] + ',\n\n'
        'Your amount for the cancelled booking has been refunded to your account.'
        'Thank you for choosing Hobbio. If you have any questions or need assistance, feel free to reach out.\n\n'
        'Best regards,\n'
        'The Hobbio Team',
        settings.EMAIL_HOST_USER,
        [email],
    )     
    
    return redirect("webadmin:cancelledbookings")

def categoryreport(request):    
    bookids = []
    catlist = []
    xlist=[]
    ylist=[]
    cdata = db.collection("tbl_category").stream()     
    for c in cdata:
        category = c.to_dict()
        sdata = db.collection("tbl_subcategory").where("category_id", "==", c.id).stream()
        for s in sdata:
            subcategory = s.to_dict()
            codata = db.collection("tbl_course").where("subcategory_id", "==", s.id).stream()
            for co in codata:
                course = co.to_dict()
                pdata = db.collection("tbl_package").where("course_id", "==", co.id).stream()
                for p in pdata:
                    package = p.to_dict()
                    bdata = db.collection("tbl_booking").where("package_id", "==", p.id).stream()
                    for b in bdata:
                        book = b.to_dict()
                        bookids.append(b.id)
        count = len(bookids)
        catlist.append({"catname": category['category_name'],"count":count})
        bookids=[]
        # print("data:",catlist)
    for i in catlist:
        
        xlist.append(i['catname'])   
        ylist.append(i['count'])
    x_json = json.dumps(xlist)
    y_json = json.dumps(ylist)
    # print("xx:",xlist)
    # print("yy:",ylist)         
    return render(request, "Admin/CategoryReport.html", {"x": x_json,"y":y_json})

def learnersreport(request):
    xlist=[]
    ylist=[]
    centerlist=[]
    bookids=[]
    cdata=db.collection("tbl_center").stream()
    for c in cdata:
        center=c.to_dict()
        codata=db.collection("tbl_course").where("center_id","==",c.id).stream()
        for co in codata:
            course=co.to_dict()
            pdata=db.collection("tbl_package").where("course_id","==",co.id).stream()
            for p in pdata:
                package=p.to_dict()
                bdata=db.collection("tbl_booking").where("package_id","==",p.id).stream()
                for b in bdata:
                        book = b.to_dict()
                        bookids.append(b.id)
        count = len(bookids)
        centerlist.append({"center": center['center_name'],"count":count})
        bookids=[]
        # print("data:",catlist)
    for i in centerlist:
        
        xlist.append(i['center'])   
        ylist.append(i['count'])
    x_json = json.dumps(xlist)
    y_json = json.dumps(ylist)
    # print("xx:",xlist)
    # print("yy:",ylist)         
    return render(request, "Admin/LearnersReport.html", {"x": x_json,"y":y_json})

def subcategoryreport(request):    
    bookids = []
    scatlist = []
    xlist=[]
    ylist=[]
    sdata = db.collection("tbl_subcategory").stream()       
    for s in sdata:        
        subcategory = s.to_dict()
        codata = db.collection("tbl_course").where("subcategory_id", "==", s.id).stream()
        for co in codata:
            course = co.to_dict()
            pdata = db.collection("tbl_package").where("course_id", "==", co.id).stream()
            for p in pdata:
                package = p.to_dict()
                bdata = db.collection("tbl_booking").where("package_id", "==", p.id).stream()
                for b in bdata:
                    book = b.to_dict()
                    bookids.append(b.id)
        count = len(bookids)
        scatlist.append({"scatname": subcategory['subcategory_name'],"count":count})
        bookids=[]
        # print("data:",catlist)
    for i in scatlist:
        
        xlist.append(i['scatname'])   
        ylist.append(i['count'])
    x_json = json.dumps(xlist)
    y_json = json.dumps(ylist)
    # print("xx:",xlist)
    # print("yy:",ylist)         
    return render(request, "Admin/SubcategoryReport.html", {"x": x_json,"y":y_json})

def logout(request):
    del request.session["aid"]
    return redirect("webguest:login")


def dashcategoryreport():    
    bookids = []
    catlist = []
    xlist=[]
    ylist=[]
    cdata = db.collection("tbl_category").stream()     
    for c in cdata:
        category = c.to_dict()
        sdata = db.collection("tbl_subcategory").where("category_id", "==", c.id).stream()
        for s in sdata:
            codata = db.collection("tbl_course").where("subcategory_id", "==", s.id).stream()
            for co in codata:
                pdata = db.collection("tbl_package").where("course_id", "==", co.id).stream()
                for p in pdata:
                    bdata = db.collection("tbl_booking").where("package_id", "==", p.id).stream()
                    for b in bdata:
                        bookids.append(b.id)
        count = len(bookids)
        catlist.append({"catname": category['category_name'],"count":count})
        bookids=[]
    return catlist

def dashlearnersreport():
    xlist=[]
    ylist=[]
    centerlist=[]
    bookids=[]
    cdata=db.collection("tbl_center").stream()
    for c in cdata:
        center=c.to_dict()
        codata=db.collection("tbl_course").where("center_id","==",c.id).stream()
        for co in codata:
            course=co.to_dict()
            pdata=db.collection("tbl_package").where("course_id","==",co.id).stream()
            for p in pdata:
                package=p.to_dict()
                bdata=db.collection("tbl_booking").where("package_id","==",p.id).stream()
                for b in bdata:
                        book = b.to_dict()
                        bookids.append(b.id)
        count = len(bookids)
        centerlist.append({"center": center['center_name'],"count":count})
        bookids=[]
    return centerlist

def dashsubcategoryreport():    
    bookids = []
    scatlist = []
    sdata = db.collection("tbl_subcategory").stream()       
    for s in sdata:        
        subcategory = s.to_dict()
        codata = db.collection("tbl_course").where("subcategory_id", "==", s.id).stream()
        for co in codata:
            course = co.to_dict()
            pdata = db.collection("tbl_package").where("course_id", "==", co.id).stream()
            for p in pdata:
                package = p.to_dict()
                bdata = db.collection("tbl_booking").where("package_id", "==", p.id).stream()
                for b in bdata:
                    book = b.to_dict()
                    bookids.append(b.id)
        count = len(bookids)
        scatlist.append({"scatname": subcategory['subcategory_name'],"count":count})
        bookids=[]
        # print("data:",catlist)
   
    return scatlist
