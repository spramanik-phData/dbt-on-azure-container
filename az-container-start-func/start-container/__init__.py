import logging

import azure.functions as func
from azure.identity import DefaultAzureCredential
from start_az_container import start_container


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    subscription_id = '983479f6-025c-4bd4-a886-3a33d5eb26eb'
    resource_group = 'rg_dbtOnAzure'

    credential = DefaultAzureCredential()
    
    container_name = req.params.get('container_name')

    if container_name:
        try:
            start_container(subscription_id, credential, resource_group, container_name)
            return func.HttpResponse("Container successfully started", status_Code=200)
        except:
            return func.HttpResponse("Issue with container start", status_Code=500)
    
    else:
        return func.HttpResponse("Pass container_name in request", status_Code=400)
