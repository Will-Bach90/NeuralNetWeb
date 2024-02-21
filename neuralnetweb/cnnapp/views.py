from django.shortcuts import render, redirect
from django.core.files.storage import FileSystemStorage
from .utils import load_and_predict_image  # Adjust the import according to your app structure
from django.conf import settings
import numpy as np

def upload_image(request):
    """Render the image upload form."""
    return render(request, 'cnnapp/upload.html')

def predict_image(request):
    """Handle image upload and prediction."""
    if request.method == 'POST' and request.FILES['image']:
        # Save the uploaded image to a temporary file
        image = request.FILES['image']
        fs = FileSystemStorage()
        filename = fs.save(image.name, image)
        uploaded_file_url = fs.path(filename)
        
        # Use the model to predict the image class
        prediction = load_and_predict_image(uploaded_file_url)
        p1 = prediction[0]
        p2 = prediction[1]
        p3 = prediction[2]
        
        # Convert prediction to a more user-friendly format
        result1 = "Pneumonia" if p1 > 0.5 else "Normal"
        result2 = "Pneumonia" if p2 > 0.5 else "Normal"
        
        # Clean up the uploaded file after prediction
        fs.delete(filename)
        
        # Render the result template with the prediction result
        return render(request, 'cnnapp/results.html', {
            'uploaded_file_url': uploaded_file_url,
            'result1': result1,
            'prediction1': p1,
            'result2': result2,
            'prediction2': p2,
            'result3': p3[0],
            'prediction3Normal': p3[1][0],
            'prediction3Viral': p3[1][1],
            'prediction3Bacterial': p3[1][2],
        })
    
    # If not POST, redirect to home page
    return redirect('home')



