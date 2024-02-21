# NeuralNetWeb
A web application showcasing the accuracy of various neural net architectures in medical image diagnostics. Allows users to upload chest x-rays to see if models can accurately predict whether a patient has pneumonia or not.

# Initial Setup  

1. Create a folder to store your project, navigate to that folder. E.g.
    ```
    mkdir CnnWeb  
    cd CnnWeb  
    ```
  
2. Clone the repo, and navigate to the neuralnetweb folder:
    ```
    git clone https://github.com/AffordabilityModelResearchGroup/neuralnetweb.git  
    cd neuralnetweb  
    ```
  
---  
### Django Development Server  
  
- Install pipenv, create virtual environment and update Pipfile.lock file, install dependencies into virtual environment, and activate virtual environment:  
    ```
    pip3 install pipenv  
    pipenv lock   
    pipenv install  
    pipenv shell  
    ```
  
- Navigate to neuralnetweb folder, and run django development server:  
    ```
    cd neuralnetweb   
    python3 manage.py runserver  
    ```
  
- Navigate to the given IP address in your browser.  
  
---
### To use nginx, gunicorn, and docker locally  
- Make sure you are in the `neuralnetweb/` parent folder and that you have docker installed and running (at the same level as `docker-compose.yml`).
- Run docker compose:
    ```
    docker compose up --build  
    ```  

- After 30 seconds or so, the images should be created and the containers running. Navigate to localhost:8443 in browser to access the website. Press ctrl-C to stop the container(s).