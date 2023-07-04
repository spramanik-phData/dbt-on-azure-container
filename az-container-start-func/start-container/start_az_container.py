from azure.mgmt.containerinstance import ContainerInstanceManagementClient

def start_container(subscription_id, credential, resource_group, container_name):

    container_client = ContainerInstanceManagementClient(credential, subscription_id)

    continer_instance_name = 'dbt-on-container-app'

    try:
        container_client.container_groups.begin_start(resource_group, continer_instance_name)
        return 1
    except:
        return -1