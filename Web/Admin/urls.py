from django.urls import path
from Admin import views

app_name = "webadmin"
urlpatterns = [
    path('adminreg/',views.AdminRegistration),
    path('adminhome/',views.AdminHome,name="adminhome"),


    path('district/',views.District,name="district"),
    path('delete_dis/<str:id>',views.delete_dis,name="delete_dis"),
    path('edit_dis/<str:id>',views.edit_dis,name="edit_dis"),

    path('category/',views.Category,name="category"),
    path('delete_cat/<str:id>',views.delete_cat,name="delete_cat"),
    path('edit_cat/<str:id>',views.edit_cat,name="edit_cat"),
   
    path('city/',views.City,name="city"),
    path('delete_city/<str:id>',views.delete_city,name="delete_city"),
    path('edit_city/<str:id>',views.edit_city,name="edit_city"),

    path('subcategory/',views.SubCategory,name="subcategory"),
    path('delete_subcat/<str:id>',views.delete_subcat,name="delete_subcat"),
    path('edit_subcat/<str:id>',views.edit_subcat,name="edit_subcat"),

    path('centerverification/',views.centerverification,name="centerverification"),
    path('center_accept/<str:id>',views.center_accept,name="center_accept"),
    path('center_reject/<str:id>',views.center_reject,name="center_reject"),
    path('center_viewmore/<str:id>',views.center_viewmore,name="center_viewmore"),

    path('viewcomplaints/',views.viewcomplaints,name="viewcomplaints"),
    path('replycomplaints/<str:id>',views.replycomplaints,name="replycomplaints"),

    path('viewfeedbacks/',views.viewfeedbacks,name="viewfeedbacks"),
]
