from django.urls import path
from Guest import views

app_name="webguest"

urlpatterns = [
     path('',views.index, name='Home'),
     path('userreg/',views.UserRegistration,name="userreg"),
     path('ajaxcity/',views.ajaxcity,name="ajaxcity"),
     path('centerreg/',views.CenterRegistration,name="centerreg"),
     path('login/',views.Login,name="login"),
     path('about/',views.about,name="about"),
     path('contact/',views.contact,name="contact"),
     path('fpassword/',views.fpassword,name="fpassword"),

    
     
    
]