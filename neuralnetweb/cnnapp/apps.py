from django.apps import AppConfig
from tensorflow.keras.models import load_model

class CnnAppConfig(AppConfig):
    name = 'cnnapp'
    verbose_name = "CNN Application"
    
    # Path to models
    model1_path = 'cnnapp/models/my_model.h5'
    model2_path = 'cnnapp/models/simplified_model.h5'
    multiClassModel_path = 'cnnapp/models/vb_model.h5'
    model1 = None
    model2 = None
    multiClassModel = None

    def ready(self):
        try:
            # Load the models
            CnnAppConfig.model1 = load_model(CnnAppConfig.model1_path)
            CnnAppConfig.model2 = load_model(CnnAppConfig.model2_path)
            CnnAppConfig.multiClassModel = load_model(CnnAppConfig.multiClassModel_path)
            print("Models loaded successfully!")
        except Exception as e:
            print(f"Failed to load model: {e}")


