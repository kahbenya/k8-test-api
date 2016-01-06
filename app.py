from flask import Flask , request
import random
import requests
import json

app = Flask(__name__)

@app.route("/")
def index():
    return "Testing 1 1 2 3\n"


@app.route("/create" , methods=['POST'])
def create():
    message = request.json['message']
    if not message:
        return "need a message"
    
    # create with k8 api

    # get the template from the file
    hellorc_tmpl = open('hellorc.json').read()


    # generate an id
    rid = random.randint(100000,2000000000)
    hellorc_tmpl = hellorc_tmpl.replace("{% ID %}",str(rid))
    hellorc_tmpl = hellorc_tmpl.replace("{% USER MSG %}", "App: hello-%d | Message: %s" % (rid,message))

    # now use the k8 api to create the rc 
    # should we pull the api info from env vars ? 
    headers = {'Content-Type' : 'application/json'}

    #create rc
    rc_req = requests.post("http://localhost:8001/api/v1/namespaces/default/replicationcontrollers", data=hellorc_tmpl, headers=headers)

    # create the corresponding servcie
    nodeport = random.randint(30200,30300)

    hellosvc_tmpl = open('hellosvc.json').read()
    hellosvc_tmpl = hellosvc_tmpl.replace("{% ID %}",str(rid))
    hellosvc_tmpl = hellosvc_tmpl.replace("{% NODEPORT %}",str(nodeport))

    svc_req = requests.post("http://localhost:8001/api/v1/namespaces/default/services", data=hellosvc_tmpl,headers=headers)
    if svc_req.status_code != 200:
        return svc_req.text, svc_req.status_code
    #print svc_req.status_code
    #print svc_req.text
    # create service

    return "done"


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0',port=5000)
