#This is a startup-script that will install an example application on the provisioned server
#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
Green='\033[0;32m'        
Yellow='\033[0;33m'       
UYellow='\033[4;33m'      

echo -e "${UYellow}Welcome to graylog setup, Please choose options below${NC}"
echo ""
echo -e "${RED}NOTE : ${NC} For ${Green}GCP (Google)${NC} key should be generated using ${Cyan} ssh-keygen -t rsa -f ~/.ssh/google_compute_engine -C ubuntu ${NC} with ${UWhite}Username${NC}"
echo ""
echo "Do you wish to generate new SSH Key for instance?"
select yn in "Yes" "No" "Exit"; do
    case $yn in
        Yes ) echo -e "New SSH key will be saved at ${Cyan} ~/.ssh/google_compute_engine ${NC} with Username ${UWhite} Ubuntu ${NC}"
        ssh-keygen -t rsa -f ~/.ssh/google_compute_engine -C ubuntu
        break;;
        No ) echo -e "Provide path of existing SSH key Example : ~/.ssh/google_compute_engine ${RED}Donot add .pub extension at last ${NC}"
        read file_path 
        export TF_VAR_ssh_file_path=${file_path:-~/.ssh/google_compute_engine}
        break;;
        Exit ) echo 'bye bye' && exit 1;;
    esac
done
echo -e "Enter GCP Project name default ${Green}default${NC}"
read gcp_project
export TF_VAR_gcp_project=${gcp_project:-default}
echo -e "Type instance name default ${Green}staging-dev-graylog${NC}"
read instance_name
export TF_VAR_instance_name=${instance_name:-staging-dev-graylog}
echo -e "Enter GCP region default ${Green}us-central1${NC}"
read gcp_region
export TF_VAR_gcp_region=${gcp_region:-us-central1}
echo -e "Enter GCP machine type default ${Green} n1-standard-1 ${NC}"
read machine_type
export TF_VAR_machine_type=${machine_type:-n1-standard-1}
echo -e "Enter Graylog disk size in GB default ${Green} 30 GB ${NC}"
read graylog_pd_ssd_size
export TF_VAR_graylog_pd_ssd_size=${graylog_pd_ssd_size:-30}
echo -e "Enter domain name for Graylog ${Green} logs.example.io ${NC} ${RED}Donot add http or https${NC}"
read domain_name
sed -i -e "s/default_server/$domain_name/g" ./scripts/logs.nginx.io
export TF_VAR_domain_name=${domain_name:-logs.example.io}
echo -e "Enter DNS zone name in GCP Cloud DNS default ${Green} public-zone ${NC}"
read dns_zone
export TF_VAR_dns_zone=${dns_zone:-dnszone}

terraform plan -out myplan
terraform apply myplan
        