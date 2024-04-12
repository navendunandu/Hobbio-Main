from django.urls import path
from Center import views

app_name = "webcenter"

urlpatterns = [

    path('centerhome/',views.CenterHome,name="centerhome"),
    path('centerprofile/',views.CenterProfile,name="centerprofile"),
    path('centereditprofile/',views.CenterEditProfile,name="centereditprofile"),
    path('centerchangepassword/',views.CenterChangePassword,name="centerchangepassword"),

    path('centeraddcourse/',views.centeraddcourse,name="centeraddcourse"),
    path('delete_course/<str:id>',views.delete_course,name="delete_course"),
   
    path('centeraddpackage/<str:id>',views.centeraddpackage,name="centeraddpackage"),
    path('delete_package/<str:id>',views.delete_package,name="delete_package"),
    path('edit_package/<str:id>',views.edit_package,name="edit_package"),

    path('centeraddimage/<str:id>',views.centeraddimage,name="centeraddimage"),
    path('delete_image/<str:id>',views.delete_image,name="delete_image"),

    path('ajaxsubcategory/',views.ajaxsubcategory,name="ajaxsubcategory"),

    path('centercomplaint/',views.centercomplaint,name="centercomplaint"),

    path('centerfeedback/',views.centerfeedback,name="centerfeedback"),

    path('viewcomplaints/',views.viewcomplaints,name="viewcomplaints"),
    path('replycomplaints/<str:id>',views.replycomplaints,name="replycomplaints"),

    path('viewbookings/',views.viewbookings,name="viewbookings"),
    path('viewratings/',views.viewratings,name="viewratings"),
    path('logout/',views.logout,name="logout"),

    
]