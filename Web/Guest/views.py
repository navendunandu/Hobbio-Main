from django.shortcuts import render,redirect
import firebase_admin
from firebase_admin import storage,auth,firestore,credentials
import pyrebase
from datetime import date


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
def UserRegistration(request):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})
    if request.method == "POST":
        email=request.POST.get("txtemail")
        password=request.POST.get("txtpassword")
        try:
            user=firebase_admin.auth.create_user(email=email,password=password)
        except(firebase_admin._auth_utils.EmailAlreadyExistsError,ValueError) as error:
            return render(request,"Guest/UserRegistration.html",{"msg":error})

        photo = request.FILES.get("txtphoto")
        if photo:
            path = "User_Photo/" + photo.name
            sd.child(path).put(photo)
            d_url = sd.child(path).get_url(None)
            

        data={"user_name":request.POST.get("txtname"),"user_contact":request.POST.get("txtcontact"),
        "user_email":request.POST.get("txtemail"),"user_gender":request.POST.get("txtgender"),
        "user_housename":request.POST.get("txthousename"),"user_area":request.POST.get("txtarea"),
        "city_id":request.POST.get("selcity"),
        "user_dob":request.POST.get("txtdob"),"user_photo":d_url,
        "user_id":user.uid}
        db.collection("tbl_user").add(data)
        return render(request,"Guest/UserRegistration.html")
    else:
        return render(request,"Guest/UserRegistration.html",{"data":dislist})

def CenterRegistration(request):
    disdata=db.collection("tbl_district").stream()
    dislist=[]
    for i in disdata:
        dis=i.to_dict()
        dislist.append({"dis_data":dis,"id":i.id})
    if request.method == "POST":
        email=request.POST.get("txtcemail")
        password=request.POST.get("txtpassword")
        try:
            center=firebase_admin.auth.create_user(email=email,password=password)
        except(firebase_admin._auth_utils.EmailAlreadyExistsError,ValueError) as error:
            return render(request,"Guest/CenterRegistration.html",{"msg":error})

        logo = request.FILES.get("txtlogo")
        if logo:
            path = "Center_Logo/" + logo.name
            sd.child(path).put(logo)
            d_url = sd.child(path).get_url(None)
        
        proof = request.FILES.get("txtproof")
        if proof:
            path = "Center_Proof/" + proof.name
            sd.child(path).put(proof)
            d_curl = sd.child(path).get_url(None)

        data={"center_name":request.POST.get("txtcname"),"center_contact":request.POST.get("txtccontact"),
        "center_email":request.POST.get("txtcemail"),"center_type":request.POST.get("seltype"),
        "center_area":request.POST.get("txtarea"),"center_building":request.POST.get("txtbuild"),
        "center_landmark":request.POST.get("txtlandmark"),
        "city_id":request.POST.get("selcity"),"center_logo":d_url,"center_proof":d_curl,
        "center_id":center.uid,"center_status":0,"center_doj":str(date.today())}
        db.collection("tbl_center").add(data)
        return render(request,"Guest/CenterRegistration.html")
    else:
        return render(request,"Guest/CenterRegistration.html",{"data":dislist})


def ajaxcity(request):
    city = db.collection("tbl_city").where("district_id", "==", request.GET.get("did")).stream()
    city_data = []
    for c in city:
        city_data.append({"city":c.to_dict(),"id":c.id})
    return render(request,"Guest/AjaxCity.html",{"city":city_data})


def Login(request):
    userid=""
    adminid=""
    if request.method=="POST":
        email=request.POST.get("txtemail")
        password=request.POST.get("txtpassword")
        try:
            data = authe.sign_in_with_email_and_password(email,password)
        except:
            return render(request,"Guest/Login.html",{"msg":"Email and password error"})
        ids=data["localId"]

        user=db.collection("tbl_user").where("user_id","==",ids).stream()
        for u in user:
            userid=u.id

        admin=db.collection("tbl_admin").where("admin_id","==",ids).stream()
        for a in admin:
            adminid=a.id

        center=db.collection("tbl_center").where("center_id","==",ids).stream()
        for c in center:
            centerid=c.id

        if userid:
            request.session["uid"]=userid
            return redirect("webuser:userhome")
        elif adminid:
            request.session["aid"]=adminid
            return redirect("webadmin:adminhome")
        elif centerid:
            request.session["cid"]=centerid
            return redirect("webcenter:centerhome")
        else:
            return render(request,"Guest/Login.html",{"msg":"Error"})
        return render(request,"Guest/Login.html")             
    else:
        return render(request,"Guest/Login.html")