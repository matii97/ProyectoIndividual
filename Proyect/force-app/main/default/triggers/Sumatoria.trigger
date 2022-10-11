trigger Sumatoria on User_Module__c (after update) {
    List<User_Module__c>TriggerNew = Trigger.New;
    List<User_Module__c>TriggerOld = Trigger.Old;
    set<Id>ChildIdentificator = new set<Id>();
    set<Id>ParentIdentificator = new set<Id>();
    for(Integer i=0;i<TriggerNew.size();i++){
        if(TriggerOld[i].Points__c != TriggerNew[i].Points__c){
            ChildIdentificator.add(TriggerNew[i].id);
            ParentIdentificator.add(TriggerNew[i].User__c);          
        }
    }
    List<User_Module__c>ChildRecords = [SELECT id, Points__c, Status__c,User__c  FROM User_Module__c WHERE id IN:ChildIdentificator];
    List<User>ParentRecords = [SELECT id,Badges__c, Points__c, (SELECT id, Status__c FROM User_Modules__r WHERE Status__c ='Completed' ) FROM User WHERE id IN:ParentIdentificator];
    for(User u:ParentRecords){
        u.Badges__c = u.User_Modules__r.size();
        for(User_Module__c um: ChildRecords){
           
            if(um.User__c == u.id){
                User_Module__c sonBeforeUpdate = Trigger.oldMap.get(um.id);
                User_Module__c sonAfterUpdate = Trigger.newMap.get(um.id);
                Double RecentlyEarnedPoints = sonAfterUpdate.Points__c - sonBeforeUpdate.Points__c;
                u.Points__c = u.Points__c + RecentlyEarnedPoints;
                
                 /*if(sonBeforeUpdate.Status__c == 'In Progress' && sonAfterUpdate.Status__c == 'Completed'){
                             u.Badges__c += 1;
                }*/
                
                
            }
        }
        
    }
    Update ParentRecords;
    
    
}