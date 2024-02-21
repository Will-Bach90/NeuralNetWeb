from django.urls import path
from . import views

urlpatterns = [
    path('', views.upload_image, name='home'),  # Home page to upload images
    path('predict/', views.predict_image, name='predict_image'),  # Path to handle image prediction
    path('upload/', views.upload_image, name='upload_image'),
]
