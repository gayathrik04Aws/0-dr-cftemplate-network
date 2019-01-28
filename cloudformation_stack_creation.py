#-- Import modules
import sys
import os.path
import json
import time
import boto3

#-- Functions
def check_status( lo_cf_client, lc_stack_name ):
    lo_stacks = lo_cf_client.describe_stacks(StackName=lc_stack_name)["Stacks"]
    la_stack = lo_stacks[0]
    lc_cur_status = la_stack["StackStatus"]
    print ("Current status of stack " + la_stack["StackName"] + ": " + lc_cur_status)
    for ln_loop in range(1, 9999):
        if "IN_PROGRESS" in lc_cur_status:
            print ("\rWaiting for status update(" + str(ln_loop) + ")...",
            time.sleep(1) )# pause 1 seconds

            try:
                lo_stacks = lo_cf_client.describe_stacks(StackName=lc_stack_name)["Stacks"]
            except:
                print (" ")
                print ("Stack " + la_stack["StackName"] + " no longer exists")
                lc_cur_status = "STACK_DELETED"
                break

            la_stack = lo_stacks[0]

            if la_stack["StackStatus"] != lc_cur_status:
                lc_cur_status = la_stack["StackStatus"]
                print (" ")
                print ("Updated status of stack " + la_stack["StackName"] + ": " + lc_cur_status)
        else:
            break

    return lc_cur_status
#-- End Functions


#-- Main program
def main( pc_param_file):

    #-- Confirm parameters file exists
    if os.path.isfile(pc_param_file):
        lo_json_data=open(pc_param_file).read()
    else:
        print ("Parameters file: " + pc_param_file + " is invalid!")
        print (" ")
        sys.exit(3)

    print ("Parameters file: " + pc_param_file)
    la_parameters_data = json.loads(lo_json_data)
    lc_region = la_parameters_data["RegionId"]

    #-- Connect to AWS region specified in parameters file
    print ("Connecting to region: " + lc_region)
    lo_cf_client = boto3.client('cloudformation', lc_region)
    print ("Connected")

    #-- Store parameters from file into local variables
    lc_stack_name = la_parameters_data["StackName"]

    #-- Check if this stack name already exists
    lo_stack_list = lo_cf_client.describe_stacks()["Stacks"]
    ll_stack_exists = False
    for lo_stack in lo_stack_list:
        if lc_stack_name == lo_stack["StackName"]:
            print ("Stack " + lc_stack_name + " already exists.")
            ll_stack_exists = True

    #-- If the stack already exists then delete it first
    if ll_stack_exists:
        #print "Stack already Exist.Enable delete to delete the existing stack."
        print ("Calling Delete Stack API for " + lc_stack_name)
        lo_cf_client.delete_stack(StackName=lc_stack_name)
        #
        # #-- Check the status of the stack deletion
        check_status(lo_cf_client, lc_stack_name)

    print(" ")
    print ("Loading parameters from parameters file:")
    la_create_stack_parameters = []
    for lc_key in la_parameters_data.keys():
        if lc_key == "TemplateUrl":
            lc_template_url = la_parameters_data["TemplateUrl"]
        elif lc_key == "StackName" or lc_key == "RegionId":
            #-- Do not send as parameters
            print (lc_key + " - "+ la_parameters_data[lc_key] + " (not sent as parameter)")
        else:
            print (lc_key + " - "+ la_parameters_data[lc_key])
            la_create_stack_parameters.append({"ParameterKey": lc_key, "ParameterValue": la_parameters_data[lc_key]})

    #-- Call CloudFormation API to create the stack   TemplateBody='',
    print (" ")
    print ("Calling CREATE_STACK method to create: " + lc_stack_name)

    lc_cur_status = ""

    la_result = lo_cf_client.create_stack(StackName=lc_stack_name, DisableRollback=False, TemplateURL=lc_template_url, Parameters=la_create_stack_parameters, Capabilities=["CAPABILITY_NAMED_IAM"])
    print ("Output from API call: ")
    print (la_result)
    print (" ")

    #-- Check the status of the stack creation
    lc_cur_status = check_status( lo_cf_client, lc_stack_name )

    if lc_cur_status == "CREATE_COMPLETE":
        print ("Stack " + lc_stack_name + " created successfully.")
    else:
        print ("Failed to create stack " + lc_stack_name)
        sys.exit(1)


#-- Call Main program
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print ("%s:  Error: %s\n" % (sys.argv[0], "Not enough command options given"))
        print ("Argument 1 (required): Stack Parameters JSON file (e.g. c:\cloud_formation\cf_stack_parameters.json)")
        print (" ")
        sys.exit(3)
    else:
        pc_param_file = sys.argv[1]

    main(pc_param_file)
