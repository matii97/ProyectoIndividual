public class UnitResponseTrigger {
	
    public static void CheckUpdate(List<User_Unit__c> UserUnitList, Map<Id,User_Unit__c> MapUnit){

		List <User_Unit__c> listFilter = new List <User_Unit__c>();
        for(User_Unit__c  ResultFilter : UserUnitList){
            if(ResultFilter.Status__C == 'Answered' && MapUnit.get(ResultFilter.id).Status__c == 'draft'){
			listFilter.add(ResultFilter);
        }
	}
	CheckAnswered(listFilter);
}
	
    public static void CheckAnswered (List<User_Unit__c> ListFilter){
        map <id, User_Unit__c> Mapfilter = new map <id, User_Unit__c> ([SELECT id, unit__r.Points__c, (SELECT Answer__r.Is_Correct__c from User_Answers__r) FROM User_Unit__c WHERE ID in: listfilter]);
            for (User_Unit__c xxx : ListFilter){
				integer contador =0;
				for (User_Answer__c respuestas : Mapfilter.get(xxx.id).User_Answers__r)						
                    if (respuestas.Answer__r.Is_Correct__c == true){
						contador ++;
					}
                if(contador == Mapfilter.get(xxx.id).User_Answers__r.size()){
					xxx.status__C = 'Success';	
			
                   		 if(xxx.Try_number__c == 1){
                      			 xxx.points__c = Mapfilter.get(xxx.id).unit__r.points__c;
                    		}else if(xxx.Try_number__c == 2){
					  			xxx.points__c = Mapfilter.get(xxx.id).unit__r.points__c/2;
                    		}else
							{ xxx.points__c = Mapfilter.get(xxx.id).unit__r.points__c/4;
										}
                }else{
					xxx.status__C= 'Fail';
					}
				
		}
	}
}