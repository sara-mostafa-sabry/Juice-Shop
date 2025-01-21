### This is a documentation for the attached task:
[Gitlab-task](../Devops_tasks(cy).pdf)

## Steps

1- Test manual
```bash
git clone https://github.com/zinmyoswe/Django-Ecommerce.git
cd Django-Ecommerce/
pip install -r requirements.txt

#Sol-1
pip3 install setuptools==45

#Sol-2
# build-essential: Contains the necessary compilation tools (like gcc).
# libffi-dev: Required for the cffi package.
# python3-dev: Provides the necessary Python headers.
# python3-pil / python3-pil.imagetk: Required for the Pillow package.
sudo apt install build-essential libffi-dev python3-dev python3-pil python3-pil.imagetk


#Sol-3
python manage.py makemigrations
python manage.py migrate

```

2- Create a Dockerfile

```Dockerfile
FROM python:3.7-slim-stretch
WORKDIR /app

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Install dependencies
RUN pip install -r Django-Ecommerce/requirements.txt

# Build the app
RUN python manage.py build

# Run unit tests
RUN pytest    

# Scan for vulnerabilities
RUN pip install safety && safety check -r Django-Ecommerce/requirements.txt
 
# Expose the port the app runs on 
EXPOSE 8000

# Command to run the app 
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

