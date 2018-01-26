global class ContactTitleCompare implements Comparable {

    public static List<String> titleHierarchy = new List<String>{
        'CEO','CxO','VP','Director','Manager'
    };

    public Contact con {get;set;}
    public Integer titleLevel {get{
        if(titleLevel == null)  titleLevel = getTitleLevelNumber(con.Title);
        return titleLevel;
    }set;}

    global Integer compareTo(Object compareTo) {
        ContactTitleCompare compareToCon = (ContactTitleCompare)compareTo;
        if(titleLevel == compareToCon.titleLevel) {
            return 0;
        } else if(titleLevel > compareToCon.titleLevel) {
            return 1;
        }
        return -1;
    }

    public ContactTitleCompare(Contact x_con) {
        this.con = x_con;
    }

    public static Integer getTitleLevelNumber(String title) {
        if(String.isNotBlank(title)) {
            for(Integer i = 0; i < titleHierarchy.size(); i++) {
                if(titleHierarchy[i] == 'CxO') {
                    if(cxoLogic(title)) {
                        return i;
                    }
                } else if(title.contains(titleHierarchy[i])) {
                    return i;
                }
            }
        }
        return titleHierarchy.size();
    }

    public static Boolean cxoLogic(String title) {
        return Pattern.matches('C[A-Za-z]{1,4}O', title);
    }
}