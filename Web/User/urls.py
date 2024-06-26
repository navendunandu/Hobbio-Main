from django.urls import path
from User import views

app_name = "webuser"
urlpatterns = [

    path('userhome/',views.UserHome,name="userhome"),
    path('userprofile/',views.UserProfile,name="userprofile"),
    path('usereditprofile/',views.UserEditProfile,name="usereditprofile"),
    path('userchangepassword/',views.UserChangePassword,name="userchangepassword"),

    path('usercomplaint/',views.usercomplaint,name="usercomplaint"),

    path('userfeedback/',views.userfeedback,name="userfeedback"),

    path('searchcenters/',views.searchcenters,name="searchcenters"),
    path('ajaxcenter/',views.ajaxcenter,name="ajaxcenter"),

    path('viewcenter/<str:id>',views.viewcenter,name="viewcenter"),
    path('viewpackages/<str:id>',views.viewpackages,name="viewpackages"),
    path('viewimages/<str:id>',views.viewimages,name="viewimages"),

    path('complainttocenter/<str:id>',views.complainttocenter,name="complainttocenter"),

    path('bookpackage/<str:id>',views.bookpackage,name="bookpackage"),
    path('payment/',views.payment,name="payment"),
    path('viewbookings/',views.viewbookings,name="viewbookings"),

    path('ajaxlike/',views.ajaxlike,name="ajaxlike"),
    path('favorites/',views.favorites,name="favorites"),
    path('favdel/<str:id>',views.favdel,name="favdel"),

    path('cancelbooking/<str:id>',views.cancelbooking,name="cancelbooking"),

    path('rating/<str:id>',views.rating,name="rating"),
    path('ajaxrating',views.ajaxrating,name="ajaxrating"),
    path('starrating/',views.starrating,name="starrating"),

    path('logout/',views.logout,name="logout"),


    

    
]