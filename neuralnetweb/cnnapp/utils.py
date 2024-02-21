from tensorflow.keras.preprocessing import image
from tensorflow.keras.models import load_model
import numpy as np
from .apps import CnnAppConfig

CLASS_INDICES = {"Normal": 0, "Viral Pneumonia": 1, "Bacterial Pneumonia": 2}

def load_and_predict_image(img_path):
    # Ensure deep model is loaded
    if CnnAppConfig.model1 is None:
        CnnAppConfig.model1 = load_model(CnnAppConfig.model1_path)
        print("Deep Model lazily loaded on first request.")
    model1 = CnnAppConfig.model1
    
    # Ensure simple model is loaded
    if CnnAppConfig.model2 is None:
        CnnAppConfig.model2 = load_model(CnnAppConfig.model2_path)
        print("Simple Model lazily loaded on first request.")
    model2 = CnnAppConfig.model2

    # Ensure multi-class model is loaded
    if CnnAppConfig.multiClassModel is None:
        CnnAppConfig.multiClassModel = load_model(CnnAppConfig.multiClassModel_path)
        print("Multi Class Model lazily loaded on first request.")
    multiClassModel = CnnAppConfig.multiClassModel

    # Load and preprocess the image
    img = image.load_img(img_path, target_size=(500, 500), color_mode="grayscale")
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)  # Create a batch
    img_array /= 255.0  # Normalize

    # Predict with each model
    prediction1 = model1.predict(img_array)
    prediction2 = model2.predict(img_array)
    prediction3 = multiClassModel.predict(img_array)

    predicted_class_index = np.argmax(prediction3, axis=1)[0]  # Assuming single image prediction
    predicted_class = list(CLASS_INDICES.keys())[list(CLASS_INDICES.values()).index(predicted_class_index)]
    probabilities = prediction3[0]

    # Return predictions for binary models and the class prediction for the multi-class model
    return [prediction1[0][0], prediction2[0][0], (predicted_class, probabilities)]

