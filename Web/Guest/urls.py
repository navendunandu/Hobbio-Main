from django.urls import path
from Guest import views

app_name="webguest"

urlpatterns = [
     path('userreg/',views.UserRegistration),
     path('ajaxcity/',views.ajaxcity,name="ajaxcity"),
     path('centerreg/',views.CenterRegistration),
     path('login/',views.Login),
    
]