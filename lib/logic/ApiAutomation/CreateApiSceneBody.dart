class CreateApiSceneBody{
  var sceneBody=Map();

  bool createBody(var scene,userId){
    try {

      sceneBody["name"] = scene[0];
      sceneBody["userId"] = userId;
      sceneBody["featured"] = true;
      sceneBody["icon"] = "light";
      sceneBody["type"] = scene[1];

      if (scene[1] == "device") {
        createDeviceBody(scene);
        createActionBody(scene);
      }
      return true;
    }
    catch(e){
      print("error in the create body:::"+e.toString());
      return false;
    }

  }
  void createDeviceBody(scene){
    var deviceBody = new Map();
    deviceBody["inDeviceId"]=scene[2];
    deviceBody["eventName"]=scene[3];
    deviceBody["stateName"]=scene[4];
    deviceBody["alwaysOn"]=true;
    deviceBody["effectiveDate"]=null;
    deviceBody["expireDate"]=null;
    deviceBody["evaluationCriteria"]="expression";

    var evaluationBody = new Map();
    evaluationBody["expression"]="";

    deviceBody["evaluationValues"]=evaluationBody;

    sceneBody["device"]=deviceBody;
  }

  void createActionBody(scene){
    var actionBody=[];
    if(scene[5]=="email"){
      createActionMail(scene, actionBody);
    }
    else if(scene[5]=="sms"){
      print("in the sms");
      createActionSms(scene,actionBody);
    }
    else if(scene[5]=="callUrl"){
      createCallUrl(scene,actionBody);
    }
    sceneBody["actions"]=actionBody;

  }
  void createActionMail(scene,actionBody){
    var actions= new Map();
    actions["sequence"]=0;
    actions["action"]=scene[5];

    var externalService= new Map();
    externalService["toAddress"]=scene[6];
    externalService["subject"]=scene[7];
    externalService["content"]=scene[8];

    actions["externalServiceData"]=externalService;
    actionBody.add(actions);

  }

  void createActionSms(scene,actionBody){
    var actions= new Map();
    actions["sequence"]=0;
    actions["action"]=scene[5];

    var externalService = new Map();
    externalService["receiverAddress"]=scene[6].toString();
    externalService["message"]=scene[7];

    actions["externalServiceData"]=externalService;
    actionBody.add(actions);
  }
  void createCallUrl(scene,actionBody){
    var actions= new Map();
    actions["sequence"]=0;
    actions["action"]=scene[5];

    var externalService = new Map();
    externalService["autherization"]=scene[6];
    externalService["callback"]=scene[7];

    actions["externalServiceData"]=externalService;
    actionBody.add(actions);
  }
}