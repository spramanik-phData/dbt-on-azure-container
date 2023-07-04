import logging
import configparser
import os

import azure.functions as func
from azure.identity import DefaultAzureCredential
from . import start_az_container


def main(req: func.HttpRequest) -> func.HttpResponse:

    logging.info('Python HTTP trigger function processed a request.')

    config = configparser.ConfigParser()
    script_dir = os.path.dirname(__file__)
    config_file = os.path.join(script_dir,'credentials.config')
    config.read(config_file)
    subscription_id = config['AZURE']['subscription_id']
    resource_group = config['AZURE']['resource_group']

    credential = DefaultAzureCredential()
	
    container_name = req.params.get('container_name')

    if container_name:
        try:
            start_az_container.start_container(subscription_id, credential, resource_group, container_name)
            return func.HttpResponse("Container successfully started", status_code=200)
        except:
            return func.HttpResponse("Issue with container start", status_code=500)
    
    else:
        return func.HttpResponse("Pass container_name in request", status_code=400)
        