<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.util.List"%>
<%@page import="com.tuc.adviser.dto.FilterDto"%>
<%@page import="com.tuc.adviser.enumeration.ParameterDataType"%>
<%@page import="com.tuc.adviser.common.AdviserConstants" %>
<%@page import="com.tuc.adviserweb.common.ApplicationConstant" %>
<jsp:useBean id="applicationConstants" scope="application"
	type="java.util.HashMap" />
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>	
<html lang="en" >
<head>
	  <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.headerName}"/>

	<!-- TITLE -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<title><spring:message code='addFilter'  /> </title>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- END TITLE -->
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">	
	<link href="common/css/jquery-ui.css" type="text/css" rel="stylesheet" />

	<link rel="stylesheet" href="common/css/TUApplCommon.css"
		type="text/css">
	<link rel="stylesheet" href="common/css/TUApplContext.css"
		type="text/css">
	<link rel="stylesheet" href="common/css/TUApplDetails.css"
		type="text/css">
	<link rel="stylesheet" href="common/css/TUApplList.css"
		type="text/css">
	<link rel="stylesheet" href="common/css/TUApplPopup.css"
		type="text/css">
	<link rel="stylesheet" href="common/css/TUApplValueSelection.css"
		type="text/css">
	<link rel="stylesheet" href="common/javascript/docsupport/style.css">
       
        <link rel="stylesheet" href="common/css/chosen.css">	
		
	<!-- STYLES -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- *** include custom styles here *** -->
	<link rel="stylesheet" href="common/css/AdviserWeb.css"
		type="text/css">
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- END STYLES -->
	
	<!-- JAVASCRIPT -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
	<!-- NEED THIS TO ALLOW USE OF COMMON FUNCTIONS -->
	<script src="common/javascript/jquery-3.5.0.js" type="text/javascript"></script>
	<script src="common/javascript/jquery-ui.js" type="text/javascript"></script>
        <script src="common/javascript/chosen.jquery.js" type="text/javascript"></script>
    
        <script type="text/javascript" src="<c:url value="/js/prototype_helpers/prototype.js"/>"></script>
	<script language="JavaScript"
		src="common/javascript/form_checks.js"></script>
	<script language="JavaScript" src="common/javascript/common.js"></script>
	<script language="JavaScript"
		src="common/javascript/sectionSelection.js"></script>
	<script language="JavaScript"
		src="common/javascript/formattingHints.js"></script>
	
<%-- DG: Checking Browser Versions --%>	
	<script language="JavaScript"
		src="common/javascript/common.js"></script>
<%-- DG --%>	

	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- Model Dialog  -->
	<script>
	var filterUsedFlag = "${filterUsedFlag}";
  jQuery( function() {
        
    var dialog = jQuery( "#dialog-confirm" ).dialog({
      autoOpen: false,
      height: 200,
      width: 420,
      modal: true,
	  closeOnEscape: true,
	  draggable: false,
	  resizable: false,
	  minHeight:false,
	  minWidth:false,
	  maxHeight:false,
	  maxWidth:false,
    });

    jQuery("#yesConfirmLink").click(function(e){
    		if(dialog.data("saveAddFlag") == false){
    			saveFilter(true , false);	
    		}
    		else{
    			saveFilter(true , true);
    		}
			dialog.dialog( "close" );
    });

    jQuery("#noConfirmLink").click(function(e){
    	var uri = "";
    	if(document.getElementById('selectedRadio').value == 'F'){
    		uri = makeURI(false, 'F', false);
    		window.opener.document.namedFilterForm.action = "copyNamedFilter.do?"+uri+"&additionalAction=addLinkedFilter";
    	}else if(document.getElementById('selectedRadio').value == 'G'){
    		uri = makeURI(false, 'G', false);
    		window.opener.document.namedFilterForm.action = "copyNamedFilter.do?"+uri+"&additionalAction=addNamedFilterGroup";
    	}
    	
		dialog.dialog( "close" );
		window.opener.document.namedFilterForm.submit();
		window.close();
    });
		
    jQuery( "#saveId" ).button().on( "click", function() {
    	if(document.getElementById('selectedRadio').value == 'F'){
    		//Calling for validation check
	      	if(saveButton1() == false){
	      		if(filterUsedFlag == 'true'){
	      			dialog.data("saveAddFlag", false);
	      			dialog.data("saveFlag", true);
		      		dialog.dialog( "open" );
	      		}else{
	      			saveFilter(false , false);
	      		}
    		}
		}
    	else if(document.getElementById('selectedRadio').value == 'G'){
    		//Calling for validation check
    	  	if(saveButton() == false){
    	  		if(filterUsedFlag == 'true'){
    	  			dialog.data("saveAddFlag", false);
	      			dialog.data("saveFlag", true);
	    	  		dialog.dialog( "open" );
    	  		}
    	  		else{
    	  			saveFilter(false , false);
    	  		}
    	  	}
    	}
    	
    	jQuery("#cancelConfirmLink").click(function(e){
        	dialog.dialog( "close" );
        });
    });
    
    jQuery( "#saveAddId" ).button().on( "click", function() {
    	if(document.getElementById('selectedRadio').value == 'F'){
    		//Calling for validation check
	      	if(saveButton1() == false){
	      		if(filterUsedFlag == 'true'){
	      			dialog.data("saveAddFlag", true);
	      			dialog.data("saveFlag", false);
		      		dialog.dialog( "open" );
	      		}
	      		else{
	      			saveFilter(false , true);	
	      		}
    		}
		}
    	else if(document.getElementById('selectedRadio').value == 'G'){
    		//Calling for validation check
    	  	if(saveButton() == false){
    	  		if(filterUsedFlag == 'true'){
    	  			dialog.data("saveAddFlag", true);
	      			dialog.data("saveFlag", false);
	    	  		dialog.dialog( "open" );
    	  		}
    	  		else{
	      			saveFilter(false , true);	
	      		}
    	  	}
    	}
      
    });
  } );
  
</script>

	<script type="text/javascript">
		jQuery.noConflict();
		jQuery(document).ready(function(){
			hide("lstOperatorStringId");
			resizeDialogWindow();
       	});

		function getOperator(val)
        {
			var filterIdObject = document.getElementById("filterId");
			var selectedValue = filterIdObject.options[filterIdObject.selectedIndex].text;
			var MOP_WITH_SPECIAL_VALUE = '<%= ApplicationConstant.COLUMN_MOP_WITH_SPECIAL_VALUE %>';
			var MX_DAY_PST_DUE = '<%= AdviserConstants.COLUMN_MX_DAY_PST_DUE %>';
			var MOP = '<%= AdviserConstants.MOP %>';
			var MONTHS_SINCE_CHARGEOFF ='<%= ApplicationConstant.COLUMN_MONTHS_SINCE_CHARGEOFF%>';
			var CVEA_MAX_MOP_FILTER ='<%= ApplicationConstant.COLUMN_CVEA_MAX_MOP_FILTER%>';
			
			if(document.getElementById($("filterId").value).value != 1 || selectedValue == MOP || selectedValue == MOP_WITH_SPECIAL_VALUE || selectedValue == MX_DAY_PST_DUE || selectedValue == MONTHS_SINCE_CHARGEOFF || selectedValue == CVEA_MAX_MOP_FILTER)
			{
				hide("lstOperatorStringId");
        		show("lstOperatorAllId", "block");
			}
			else
			{
				hide("lstOperatorAllId");
	        	show("lstOperatorStringId", "block");
			}
		
        }
		var objPassedParentWindow = window.dialogArguments;	
		function saveFilter(updationFlag, saveAddMoreFlag)
		{
			if(document.getElementById('selectedRadio').value == '')
			{
				alert("<spring:message code='infoLabel_RadioName' />");
				return;
			}
			
			if(document.getElementById('selectedRadio').value == 'F')
			{
				$("saveId").disabled = true;
				$("saveAddId").disabled = true;  
                ajaxFunction("addLinkedFilter.do", makeURI(updationFlag, 'F', true));
				
				if(saveAddMoreFlag == true){
					window.opener.location = encodeURI(window.opener.location.href);
					resetToDefault();
					document.getElementsByName("filter")[0].checked = true;	
				}
				else{
					window.close();
					window.opener.location = encodeURI(window.opener.location.href);
					return true;	
				}
			}
			else if(document.getElementById('selectedRadio').value == 'G')
			{
				$("saveId").disabled = true;
				$("saveAddId").disabled = true;  
                ajaxFunction("addNamedFilterGroup.do", makeURI(updationFlag, 'G', true));
				
				if(saveAddMoreFlag == true){
					window.opener.location = encodeURI(window.opener.location.href);
					resetToDefault();
					document.getElementsByName("filter")[1].checked = true;
					enableDisableField();
				}else{
					window.close();
					window.opener.location = encodeURI(window.opener.location.href);
				}
			}
		}
		
		function cancelClick()
		{				
			window.close();
		}
		
		function makeURI(updationFlag, filterType, namedFilterIdFlag)
		{
			var uriParam="";
			var namedFilterId = document.namedFilterForm.namedFilterId.value;
			if(filterType == 'F')
			{
				 var filterId = document.namedFilterForm.filterId.value;
                 var operatorParameter;
                 var filterIdObject = document.getElementById("filterId");
                 var selectedValue = filterIdObject.options[filterIdObject.selectedIndex].text;
                 var MOP_WITH_SPECIAL_VALUE = '<%= ApplicationConstant.COLUMN_MOP_WITH_SPECIAL_VALUE %>';
                 var MX_DAY_PST_DUE = '<%= AdviserConstants.COLUMN_MX_DAY_PST_DUE %>';
                 var MOP = '<%= AdviserConstants.MOP %>';
                 var MONTHS_SINCE_CHARGEOFF ='<%= ApplicationConstant.COLUMN_MONTHS_SINCE_CHARGEOFF%>';
                 var CVEA_MAX_MOP_FILTER ='<%= ApplicationConstant.COLUMN_CVEA_MAX_MOP_FILTER%>';
                 var specialValue = document.namedFilterForm.specialValue.value;
                 var filterName = $("filterId").options[$("filterId").selectedIndex].text;
                 if(($("filterId").value != null && $("filterId").value != "" && document.getElementById($("filterId").value).value != 1) || selectedValue == MOP || selectedValue == MOP_WITH_SPECIAL_VALUE || selectedValue == MX_DAY_PST_DUE || selectedValue == MONTHS_SINCE_CHARGEOFF || selectedValue == CVEA_MAX_MOP_FILTER)
				 {
				 	operatorParameter = $("operatorParameter1").value;
				 }
				 else
				 {
					operatorParameter = $("operatorParameter2").value;
				 }
                 var valueParameter = document.namedFilterForm.valueParameter.value;
				 uriParam="returnTo=filterDetail&filterId="+filterId+"&operatorParameter="+operatorParameter+"&valueParameter="+escape(valueParameter)+"&specialValue=" +specialValue+"&filterName=" +filterName+"&updationFlag="+updationFlag;
			}
			else
			{
	             var namedFilterID = document.namedFilterForm.namedFilterIDTemp.value;
	             var namedFilterName = $("namedFilterIDTemp").options[$("namedFilterIDTemp").selectedIndex].text;
	             uriParam="returnTo=namedFilterDetail&parentNamedFilterId="+namedFilterId+"&childNamedFilterId="+namedFilterID+"&childNamedFilterName=" +namedFilterName+"&updationFlag="+updationFlag;
			}
			if(namedFilterIdFlag == true){
				 uriParam=uriParam+"&namedFilterId="+namedFilterId; 
			 }
			return uriParam;
		}
		function resetToDefault()
		{
			location.reload();
			document.namedFilterForm.reset();
			$("saveId").disabled=false;
            $("saveAddId").disabled=false;
			hide("lbl_valueParameter1");
			hide("lbl_valueParameter2");
			hide("valueParameter1");
			hide("err_valueParameter");
			hide("VALUE_Y");
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_Filter'  />';
		}
		
		// Add filter
		function saveButton1() 
		{
			var flag = false;
			hide("filterErrorMessage");
			setObjectClass("filterNameId", "required");
			setObjectClass("operatorNameId", "required");
			setObjectClass("valueNameId", "required");
			var value = "";
			var filter_param_name="";
			var mx_mpdVal='<%= (String)applicationConstants.get("maxDPDValue")%>';
		    var filterMxMpdFlag = false;
		    var value_y='<%= (String)applicationConstants.get("VALUE_Y")%>';
		    var valueYFlag = false;
			var mopVal='<%= (String)applicationConstants.get("mop")%>';
			var mopSpecialVal='<%=(String) applicationConstants.get("mopSpecialValue")%>';
			var filterMOPFlag = false;
			var monthsincechargeoff='<%= (String)applicationConstants.get("monthsincechargeoffValue")%>';
			var filtermonthsincechargeoffFlag = false;
			var filterChargeOffFlag = false;
			var chargeoff='<%= (String)applicationConstants.get("dpdValue")%>';
			var maxMopFilter = false;
			var maxMopFilterVal = '<%=(String) applicationConstants.get("maxMopFilter")%>';
			var woSettledStatusHistory = false;
			var suitFiledStatus = false;
			var currentMop = false;
			var currentBalance = false;
			var emiAmt = false;
			var assetClassification = false;
			if($("filterId").value == "") {
				show("filterErrorMessage", "block");
				setObjectClass("filterNameId", "requiredError");
				flag = true;
			}
			else if($("filterId").value == parseInt('<%=(String) applicationConstants.get("woSettledStatusHistory")%>'))
     		{
				woSettledStatusHistory = true;
	           	value = document.getElementById($("filterId").value).value;
     		}
			else if($("filterId").value == parseInt('<%=(String) applicationConstants.get("suitFiledStatus")%>'))
     		{
				suitFiledStatus = true;
	           	value = document.getElementById($("filterId").value).value;
     		}
			else if($("filterId").value == parseInt('<%=(String) applicationConstants.get("currentMop")%>'))
     		{
				currentMop = true;
	           	value = document.getElementById($("filterId").value).value;
     		}
			else if($("filterId").value == parseInt('<%=(String) applicationConstants.get("currentBalance")%>'))
     		{
				currentBalance = true;
	           	value = document.getElementById($("filterId").value).value;
     		}
			else if($("filterId").value == parseInt('<%=(String) applicationConstants.get("emiAmt")%>'))
     		{
				emiAmt = true;
	           	value = document.getElementById($("filterId").value).value;
     		}
			else if($("filterId").value == parseInt('<%=(String) applicationConstants.get("assetClassification")%>'))
     		{
				assetClassification = true;
	           	value = document.getElementById($("filterId").value).value;
     		}
			else if($("filterId").value == parseInt(mx_mpdVal ))
             		{
	                   filterMxMpdFlag=true;
        	           value = document.getElementById($("filterId").value).value;
             		}
			 else if($("filterId").value == parseInt(mopVal ) || $("filterId").value == parseInt(mopSpecialVal ))
                        {
                           filterMOPFlag=true;
                           value = document.getElementById($("filterId").value).value;
                        }
			else if($("filterId").value == parseInt(maxMopFilterVal))
            {
				maxMopFilter = true;
            	value = document.getElementById($("filterId").value).value;
            }
			else if($("filterId").value == parseInt(monthsincechargeoff))
            		{
            			filtermonthsincechargeoffFlag=true;
            			value = document.getElementById($("filterId").value).value;
            		}

            else if($("filterId").value == parseInt(value_y))
             		{
	                   valueYFlag=true;
        	           value = document.getElementById($("filterId").value).value;
             		}
            else if($("filterId").value == parseInt(chargeoff))
            {
            	filterChargeOffFlag = true;
            	value = document.getElementById($("filterId").value).value;
            }
			else {
				value = document.getElementById($("filterId").value).value;
			}	
			if(document.getElementById($("filterId").value).value != 1 && $("operatorParameter1").value == "") {
				show("filterErrorMessage", "block");
				setObjectClass("operatorNameId", "requiredError");
				flag = true;
			}
			else if(document.getElementById($("filterId").value).value == 1 && $("operatorParameter2").value == "")
			{
				show("filterErrorMessage", "block");
				setObjectClass("operatorNameId", "requiredError");
				flag = true;
			}
			if(trim($("valueParameter").value) == "") {
				show("filterErrorMessage", "block");
				setObjectClass("valueNameId", "requiredError");
				flag = true;
			}
			if(trim($("valueParameter1").value) == "" && trim($("valueParameter").value) == "") 			     
			{
			      if(filterMxMpdFlag || valueYFlag)
  		              {
                		   show("filterErrorMessage", "block");
		                   setObjectClass("valueNameId1", "requiredError");
                		   flag = true;
                	      }
			      if(filtermonthsincechargeoffFlag)
		              {
            		   	show("filterErrorMessage", "block");
	                   	setObjectClass("lbl_valueParameter2", "requiredError");
            		   	flag = true;
            	      	     }
		         } 
			 else if(value != ""){
				var param_value = trim($("valueParameter").value);
				 if(filterMxMpdFlag)
				{
					if(!flag)	
					{
						param_value = trim($("valueParameter").value) +'<%=com.tuc.adviser.common.AdviserConstants.MAX_DPD_FILTER_VALUE_SEPERATOR%>'+trim($("valueParameter1").value);
						$("valueParameter").value=param_value;
					}
				}
				if(valueYFlag)
				{
					if(!flag)	
					{
						param_value = trim($("valueParameter").value) +'<%=com.tuc.adviser.common.AdviserConstants.MAX_DPD_FILTER_VALUE_SEPERATOR%>'+trim($("valueParameter1").value);
						$("valueParameter").value=param_value;
					}
				}
				 if(filterMOPFlag)
                                {
                                        if( trim($("valueParameter1").value) != "")
                                        {
                                                param_value = trim($("valueParameter").value) +'<%=com.tuc.adviser.common.AdviserConstants.MAX_DPD_FILTER_VALUE_SEPERATOR%>'+trim($("valueParameter1").value);
                                                $("valueParameter").value=param_value;
                                        }
                                }
                                 if(filtermonthsincechargeoffFlag)
                                {
                                        if(trim($("valueParameter1").value) != "")
                                        {
                                                param_value = trim($("valueParameter").value) +'<%=com.tuc.adviser.common.AdviserConstants.MAX_DPD_FILTER_VALUE_SEPERATOR%>'+trim($("valueParameter1").value);
                                                $("valueParameter").value=param_value;
                                        }
                                }
				if(filterChargeOffFlag || maxMopFilter || woSettledStatusHistory || suitFiledStatus || currentMop || currentBalance || assetClassification || emiAmt)
				{
					if(!flag)	
					{
							if($("valueParameter1").value != undefined && trim($("valueParameter1").value) != "")
							{
								param_value = trim($("valueParameter").value) +'<%=com.tuc.adviser.common.AdviserConstants.MAX_DPD_FILTER_VALUE_SEPERATOR%>'+trim($("valueParameter1").value);
		                        $("valueParameter").value=param_value;	
							}
							else
							{
								param_value = trim($("valueParameter").value);
		                        $("valueParameter").value=param_value;	
							}
                    }
				}
				param_valueArray = param_value.split('<%=(String) applicationConstants.get("filterValueDelimiter")%>');
				if(value == '<%=ParameterDataType.DATE.getId()%>'){
					value = '<%=ParameterDataType.INTEGER.getId()%>';
				}
				for(ii=0;ii<param_valueArray.length;ii++)
				{
					if(!(woSettledStatusHistory) && !(suitFiledStatus) && !(currentMop) && !(currentBalance) && !(assetClassification) && !(emiAmt) && checkValidation("Y", value, trim(param_valueArray[ii]), $("filterId").value) == false) 
					{
						show("filterErrorMessage", "block");
						setObjectClass("valueNameId", "requiredError");
						flag = true;
						break;
					}
				}
			}
			return flag;
		}
		
		// Add Group
		function saveButton() 
		{
			var flag = false;
			hide("filterErrorMessage");
			setObjectClass("namedFilterIdArray", "required");
			var value = "";
			if($("namedFilterIDTemp").value == "") 
			{
				show("filterErrorMessage", "block");
				setObjectClass("namedFilterIdArray", "requiredError");
				flag = true;
			} 
			return flag;
		}
		
	
	function enableDisableField()
        {
                if(document.getElementsByName("filter")[0].checked)
		{
                document.getElementById("namedFilterIDTemp").disabled=true;
                document.getElementById("filterId").disabled=false;
                document.getElementById("operatorParameter1").disabled=false;
                document.getElementById("operatorParameter2").disabled=false;
                document.getElementById("valueParameter").disabled=false;
		 document.getElementById("specialValueId").disabled=false;
		document.getElementById('selectedRadio').value="F";
		jQuery('#filterId').prop('disabled',false).trigger("chosen:updated");
                }
                if(document.getElementsByName("filter")[1].checked)
                {
                document.getElementById("namedFilterIDTemp").disabled=false;
                document.getElementById("filterId").disabled=true;
                document.getElementById("operatorParameter1").disabled=true;
                document.getElementById("operatorParameter2").disabled=true;
                document.getElementById("valueParameter").disabled=true;
		document.getElementById("specialValueId").disabled=true;
		document.getElementById('selectedRadio').value="G";
		jQuery('#filterId').prop('disabled',true).trigger("chosen:updated");
                }
        }
	
	</script>

<script type="text/javascript">	
	var myHints=new Array(100); //Global Array Allocation
	
 	 var token=document.getElementsByName('_csrf')[0].getAttribute('content');
         var header=document.getElementsByName('_csrf_header')[0].getAttribute('content');
	
	
	//This is a map between Java and JScript Code to access Filter Description parameters from DTO List
	function setFilterHintMessages()
	{
	<c:if test="${not empty requestScope['filterDtoList']}">
		<c:forEach var='item' items="${requestScope['filterDtoList']}" >
		   myHints[${item.filterID}]="<spring:message code='${item.filterDesc}' text='${item.filterDesc}' />";
		</c:forEach>
	</c:if>
			
	
	}
	function IncText()
	{
		Tip(myHints[document.namedFilterForm.filterId.value], BGCOLOR, '#FFFFCC', SHADOW, true); 
	}

	function getHintOnFilterChange(iPosition)
	{
		if (browser == "ie") {
			document.getElementById('valueParameter').detachEvent("onmouseover", IncText);
			document.getElementById('valueParameter').attachEvent("onmouseover", IncText);
		}
		else {
			document.getElementById('valueParameter').removeEventListener('mouseover',function dg(){}, false); //event bubbling (false) 
			document.getElementById('valueParameter').addEventListener('mouseover', 
														function dg() {  
															Tip(myHints[iPosition], BGCOLOR, '#FFFFCC', SHADOW, true); 
														}, 
														true);
		}													
	}
	
	setFilterHintMessages(); //onInit load
	
	function setSelectedRadio(val)
	{
		hide("filterErrorMessage");
		setObjectClass("filterNameId", "required");
		setObjectClass("operatorNameId", "required");
		setObjectClass("valueNameId", "required");
		setObjectClass("namedFilterIdArray", "required");
		document.getElementById('selectedRadio').value = val.value;
		enableDisableField();
	}
	
	function getSelectFilterParameterValue(val)
	{
		hide("lbl_valueParameter1");
		hide("lbl_valueParameter2");
		hide("lbl_valueParameter3");
		hide("valueParameter1");
		hide("VALUE_Y");
		hide("MONTH_RANGE");
		hide("err_valueParameter");
		hide("DPD_Value");
		if(val=='<%=(String) applicationConstants.get("maxDPDValue")%>'|| val=='<%=(String) applicationConstants.get("mop")%>'|| val=='<%=(String) applicationConstants.get("mopSpecialValue")%>' || val=='<%=(String) applicationConstants.get("maxMopFilter")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter1", "block");
			show("lbl_valueParameter2", "block");
		     	show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("VALUE_Y")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter1", "block");
			show("VALUE_Y", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("monthsincechargeoffValue")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterY'  />';
			show("lbl_valueParameter3", "block");
			show("DPD_Value", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("dpdValue")%>' || val=='<%=(String) applicationConstants.get("dpdWithSpecialValue")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter3", "block");
			show("DPD_Value", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("woSettledStatusHistory")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter1", "block");
			show("MONTH_RANGE", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("suitFiledStatus")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter3", "block");
			show("MONTH_RANGE", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("currentMop")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter3", "block");
			show("MONTH_RANGE", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("currentBalance")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter3", "block");
			show("MONTH_RANGE", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("assetClassification")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter3", "block");
			show("MONTH_RANGE", "block");
			show("valueParameter1", "block");
		}
		else if(val=='<%=(String) applicationConstants.get("emiAmt")%>') 
		{
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_FilterX'  />'; 
			show("lbl_valueParameter3", "block");
			show("MONTH_RANGE", "block");
			show("valueParameter1", "block");
		}
		else
		{	
			document.getElementById("lbl_valueParameter").innerHTML='<spring:message code='Value_Filter'  />';
		}
	}	
	function ajaxFunction(actionName,uriParam)
	{
         var httpxml;
         try
         {
             // Firefox, Opera 8.0+, Safari
             httpxml=new XMLHttpRequest();
         }
                catch (e)
                {
                        // Internet Explorer
                        try
                        {
                                httpxml=new ActiveXObject("Msxml2.XMLHTTP");
                        }
                        catch (e)
                        {
                                try
                                {
                                        httpxml=new ActiveXObject("Microsoft.XMLHTTP");
                                }
                                catch (e)
                                {
                                        alert("Your browser does not support AJAX!");
                                        return false;
                                }
                                }
                        }
                        uriParam=uriParam+"&sid="+Math.random();
                        httpxml.open("POST", actionName, false);
                        httpxml.setRequestHeader("Content-type","application/x-www-form-urlencoded");
			 httpxml.setRequestHeader(header, token);
                        httpxml.send(uriParam);
                        return true;
        }
 		function sleep(milliseconds) 
 		{
           var start = new Date().getTime();
           for (var i = 0; i < 1e7; i++) {
           if ((new Date().getTime() - start) > milliseconds){
              break;
         }
      }
 }

     function alphanumericCommaOnly(event)
	{
        //For Firefox it returns we can get keyCode from event.which
        // For Firefox -- navigator.appName.search("Microsoft") returns -1.

        var str;
		var flag = true;
		if($("filterId").value != parseInt('<%=(String) applicationConstants.get("woSettledStatusHistory")%>') && $("filterId").value != parseInt('<%=(String) applicationConstants.get("suitFiledStatus")%>') && $("filterId").value != parseInt('<%=(String) applicationConstants.get("currentMop")%>')&& $("filterId").value != parseInt('<%=(String) applicationConstants.get("currentBalance")%>')&& $("filterId").value != parseInt('<%=(String) applicationConstants.get("emiAmt")%>')&& $("filterId").value != parseInt('<%=(String) applicationConstants.get("assetClassification")%>')){
	        if(navigator.appName.search("Microsoft") != -1){
	            str = event.keyCode;
	         }else{
	            str = event.which;
	         }
	        if(!alphanumericCommaOnlyStr(str))
	        {
	            show("filterErrorMessage", "block");
	            setObjectClass("valueNameId", "requiredError");
				flag = false;
	        }
		}
		return flag;
    }
</script>


<base target="_self">
</head>
<body>

<!-- DG: ================================================================================ -->
<script type="text/javascript" src="js/wz_tooltip.js"></script>
<!-- DG: ================================================================================ -->
<%@include file="/jsp/pageBodyConfirmUpdation.jsp"%>
<div id="fixedPopupArea" style="display:block;">
	<div class="popupForm" id="critDetailsForm" style="display:block;">
	<div class="popupFormDisplayArea">

	<div class="dataArea" id="editCritDetailsData" style="display:block;">
		<div class="formPopupCloseLink">
			<a href="#" onclick="javascript:cancelClick()"><spring:message code='Close_Link'  /></a>
			<span class="linkIconRight">
				<a href="#" onclick="javascript:cancelClick()"><img src="common/images/close.gif" alt="Close"/></a>				
			</span>
		</div>

	<div class="titleArea">
		<h1 id="addTitle" style="display:block;"><spring:message code='addFilter'  /></h1>
	</div>
	
	<div id="filterErrorMessage" class="contentPageMessageArea" style="display:none;">
		<div class="errorArea">
			<div class="details">
				<h4><spring:message code='errMsgGeneral'  /></h4>
			</div>
		</div>
	</div>
	<div class="introductionArea">
	<p><span class="key"><span class="icon"><img src="common/images/required_key.gif" alt="Required" /></span><span class="required"><spring:message code='requiredfield'  /></span></p>
	
	</div>
	
	<form:form onsubmit="return false;" action="createNamedFilter.do" modelAttribute="namedFilterForm" name="namedFilterForm">
	
	<form:hidden path="namedFilterId" />

	<input id="selectedRadio" type="hidden" value="F"/>
	
	<div class="formArea">
		<div class="formFieldSection">
		<div class="sectionHeaderArea" style="width:894px">
		<span class="sectionControls"></span>
		<h3><spring:message code='filterDetails'  /></h3>
		<span class="sectionActions"></span>
		</div>
		
		<table id="filterDetailsTable" style="width: 100%;border: 0px solid #FFFFFF">
		<th/>
		<tr id="filterDetailsRow">
		<div class="formFields1Column">
		<div class="firstColumnArea">
		<td id="filterDetailsCol1" style="width: 50%;">
		<input id="radioId" checked type="radio" name="filter" style="align:left;" value="F" onclick="setSelectedRadio(this);"><b>&nbsp;<spring:message code="Individual_Filter"/></b></input>
			<div class="groupArea">
				<div class="fieldArea">
				<div id = "filterNameId" class="required">
				<span class="labelIconLeft"><img src="common/images/required.gif" alt="Required" /></span>
				<span class="label"><spring:message code='Filter_Name'  /></span>
				<span class="input">

<%-- DG: --%>
			<form:select path="filterId"  cssClass="chosen-select" style="width:350px;" id="filterId" 
						onchange="getHintOnFilterChange(this.options[this.selectedIndex].value);getSelectFilterParameterValue(this.options[this.selectedIndex].value);getOperator(this.options[this.selectedIndex].value)">
					<form:option value=""></form:option>
                                    <c:if test="${not empty filterDtoList}" >
                                    <c:forEach items="${filterDtoList}" var="filterDto" >
                                        <form:option value="${filterDto.filterID}" ><spring:message code="${filterDto.filterName}" text="${filterDto.filterName}" /></form:option>
                                    </c:forEach>
                                    </c:if>
				</form:select>
<%--DG: --%>
				</span>



				<span class="error"><spring:message code='errLabel_Filter'  /></span>
				</div>
				<div id = "operatorNameId" class="required">
				<span class="labelIconLeft"><img src="common/images/required.gif" alt="Required" /></span>
				<span class="label"><spring:message code='Operator_Details_Filter'  /></span>
				<span class="input" id="lstOperatorAllId">
					<form:select path="operatorParameter"  class="selectBox200" id="operatorParameter1">
					<option selected="selected"></option>
					<c:if test="${not empty lstOperators}" >
                                    <c:forEach items="${lstOperators}" var="tval">
                                   		<form:option value="${tval}">${tval}</form:option>
 									</c:forEach>                               
                                </c:if>
                       
					</form:select>
				</span>
				<span class="input" id="lstOperatorStringId">
					<form:select path="operatorParameter"  cssClass="selectBox200" id="operatorParameter2">
						<c:if test="${not empty lstOperatorString}" >
                                    <c:forEach items="${lstOperatorString}" var="tval">
                                    <form:option value="${tval}">${tval}</form:option>
                                </c:forEach>
                                </c:if>>
					</form:select>
				</span>
				<span class="error"><spring:message code='infoLabel_FilterCondition'  /></span>
				</div>
				<div  id = "valueNameId" class="required">
				<span class="labelIconLeft"><img src="common/images/required.gif" alt="Required" /></span>
				<span class="label" id="lbl_valueParameter" name="lbl_valueParameter" ><spring:message code='Value_Filter'  /></span>
				<span class="input">

<%-- DG: Value Box. The "onMouseOver' event is dynamicly generated via jscript on each Filter' Combo Box change  --%>


<input 	type="text"  
		class="inputBox200"  
		id="valueParameter" 
		name="valueParameter"
		property="valueParameter" 
		maxlength="500"
		onmouseout="UnTip()"
		onfocus="UnTip()"
		onkeypress="return alphanumericCommaOnly(event)"
		 />
<%-- DG --%>
	</span>
	 <span class="error"><spring:message code='errLabel_Value'  />
	</div>
	 <div  id = "valueNameId1" class="required">
	</span>
	<span class="labelIconLeft" id="lbl_valueParameter1" name="lbl_valueParameter1" style="display:none"><img src="common/images/required.gif" alt="Required" /></span>
<span class="labelIconLeft" id="lbl_valueParameter3" name="lbl_valueParameter3" style="display:none"></span>
	<span class="label" id="lbl_valueParameter2" name="lbl_valueParameter2" style="display:none"><spring:message code='Value_FilterY'  /></span>
	<span class="label" id="DPD_Value" name="DPD_Value" style="display:none" ><spring:message code='DPD_Value'  /></span>
	<span class="label" id="VALUE_Y" name="VALUE_Y" style="display:none"><spring:message code='VALUE_Y'  /></span>
	<span class="label" id="MONTH_RANGE" name="MONTH_RANGE" style="display:none"><spring:message code='MONTH_RANGE'  text="MONTH_RANGE" /></span>
	<span class="input">
		<input 	style="display:none" 
		type="text"  
		class="inputBox200"  
		id="valueParameter1" 
		name="valueParameter1" 
		maxlength="5"
		onmouseout="UnTip()"
		onfocus="UnTip()"
		onkeypress="return alphanumericCommaOnly(event)"
		 />
<%-- DG --%>
		</span>
		<span class="error" id="err_valueParameter"><spring:message code='errLabel_Value'  />
		</div>	
	
		<div  id = "specialValueId" class="required">
			<span class="labelIconLeft" id="lbl_valueParameter1" name="lbl_valueParameter1" style="display:block"></span>
			<span class="label" id="SPECIAL_VALUE" name="SPECIAL_VALUE" style="display:block"><spring:message code='SPECIAL_VALUE'/></span>

			<span class="input">
			<input 	style="display:block" 
				type="text"  
				class="inputBox200"  
				styleId="mandatoryText"  
				id="specialValue" 
				name="specialValue" 
				property="specialValue" 
				maxlength="10"
				onmouseout="UnTip()"
				onfocus="UnTip()"
			 />
			</span>
		</div>
		
		<c:if test="${not empty filterDtoList}" >
						<%  List<FilterDto> filterDtoList = (List)request.getAttribute("filterDtoList"); 
							for(int ii = 0; ii<filterDtoList.size(); ii++) {
						%>
								<input type = "hidden" id = "<%=filterDtoList.get(ii).getFilterID()%>" name = "<%=filterDtoList.get(ii).getFilterID()%>" value = "<%=filterDtoList.get(ii).getFilterDataType().getId()%>"> 		
						<% 	}
						
						%>
					</c:if>
			
				</div>
			</div>
		</td>
		<td id="filterDetailsCol2" style="width: 50%;">
		<input id="radioId" type="radio" name="filter" style="align:left;" value="G" onclick="setSelectedRadio(this);"><b>&nbsp;<spring:message code="Filter_Group"/></b></input>
			<div class="groupArea">
				<div class="fieldArea">
				
				<div id = "namedFilterIdArray" class="required">
				<span class="labelIconLeft"><img src="common/images/required.gif" alt="Required" /></span>
				<span class="label"><spring:message code='Filter_Group_Name'  /></span>
				<span class="input">

<%-- DG: --%>
			<form:select path="namedFilterIDTemp"  cssClass="chosen-select" id="namedFilterIDTemp" >
					<form:option value=""></form:option>
					<c:if test="${not empty userNamedFilterDtoList}" >
					      <c:forEach items="${userNamedFilterDtoList}" var="userNamedFilterDto">
                             <form:option value="${userNamedFilterDto.namedFilterID}"><c:out value="${userNamedFilterDto.namedFilterName}"/></form:option>
                           </c:forEach>
                    </c:if>
				</form:select>
<%--DG: --%>
				</span>
				<span class="error"><spring:message code='errLabel_Filter_Group'  /></span>
				</div>
				
				
				</div>
			</div>
		</td>
		</div>
		</div>
		</tr>
		</table>
		<!-- HACK TO MAKE THE BORDER STRETCH -->
		<div class="contentStretchHackLeft">&nbsp;</div>
		<div class="contentStretchHackRight">&nbsp;</div>
		<!-- END BORDER HACK -->
		</div>

		<!-- FORM ACTIONS -->
		<div class="formActionSection">
		<div class="sectionHeaderArea">
		<h3>Action Section Title</h3>
		</div>
		<div id="addButtons" class="formActionsVertical" style="display:block;">
			<div class="actionArea" style="margin-right:0px">
				<div class="action">
					<span class="button">
						<input type="text" style="width:0px;height:0px;border:none"/>
					</span>
				</div>
				<div class="action">
					<span class="button" style="margin-right:140px">
						<input type="button" id="saveId" class="button" value="<spring:message code='createnewjobcontents2'  />">				
						<input type="button" id="saveAddId" class="button" value="<spring:message code='saveAndAdd'  />">				
					<input name="Cancel" type="button" onclick="javascript:cancelClick();" class="buttonCancel" value="<spring:message code='Cancel_Button'  />">
				</span></div>
			</div>
		</div>
		</div>
	</div>
</form:form>
	<!-- BOTTOM FINDER HACK -->
<div class="bottomFinder"><img src="common/images/pixel_clear.gif" alt="img details bottom finder" id="editCritDetailsBottomFinder">&nbsp;</div>
	<!-- END BORDER HACK -->
	</div>
	</div>
	</div>
</div>
	<script type="text/javascript">
                var x = jQuery.noConflict();
                var config11 =
                {
                        '.chosen-select'           : {width:"200px"},
                        '.chosen-select-deselect'  : {allow_single_deselect:true},
                        '.chosen-select-no-single' : {disable_search_threshold:10},
                        '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
                }
                for (var selector1 in config11)
                {
                        jQuery(selector1).chosen(config11[selector1]);
                }
		enableDisableField();
        </script>
</body>
</html>
