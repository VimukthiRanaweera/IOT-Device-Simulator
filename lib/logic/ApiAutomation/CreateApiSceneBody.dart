class CreateApiSceneBody{
  var sceneBody=Map();

  bool createBody(var scene,userId){
    try {

      sceneBody["name"] = scene[0];
      sceneBody["userId"] = userId;
      sceneBody["featured"] = true;
      sceneBody["icon"] = "light";
      sceneBody["type"] = "device";


        createDeviceBody(scene);
        createActionBody(scene);

      return true;
    }
    catch(e){
      print("error in the create body:::"+e.toString());
      return false;
    }

  }
  void createDeviceBody(scene){
    var deviceBody = new Map();
    deviceBody["inDeviceId"]=scene[1];
    deviceBody["eventName"]=scene[2];
    deviceBody["stateName"]="none";
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
    if(scene[3]=="email"){
      createActionMail(scene, actionBody);
    }
    else if(scene[3]=="sms"){
      print("in the sms");
      createActionSms(scene,actionBody);
    }
    else if(scene[3]=="callUrl"){
      createCallUrl(scene,actionBody);
    }
    sceneBody["actions"]=actionBody;

  }
  void createActionMail(scene,actionBody){
    var actions= new Map();
    actions["sequence"]=0;
    actions["action"]=scene[3];

    var externalService= new Map();
    externalService["toAddress"]=scene[4];
    externalService["subject"]=scene[5];
    externalService["content"]=scene[6];

    actions["externalServiceData"]=externalService;
    actionBody.add(actions);

  }

  void createActionSms(scene,actionBody){
    var actions= new Map();
    actions["sequence"]=0;
    actions["action"]=scene[3];

    var externalService = new Map();
    externalService["receiverAddress"]=scene[4].toString();
    externalService["message"]=scene[5];

    actions["externalServiceData"]=externalService;
    actionBody.add(actions);
  }
  void createCallUrl(scene,actionBody){
    var actions= new Map();
    actions["sequence"]=0;
    actions["action"]=scene[3];

    var externalService = new Map();
    externalService["autherization"]="NoAuth";
    externalService["callback"]=scene[4];

    actions["externalServiceData"]=externalService;
    actionBody.add(actions);
  }
}