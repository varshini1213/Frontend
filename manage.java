/***********************************************************
 *		System:			Adviser
 *		Description:	
 *
 ***************************************************************
 *		� Copyright 2017 Trans Union LLC.  All Rights Reserved.
 *		
 *		No part of this work may be reproduced or distributed in any
 *		form or by any means, electronic or otherwise, now known or
 *		hereafter developed, including, but not limited to, the
 *		Internet, without the explicit prior written consent from
 *		Trans Union LLC.
 *		
 *		Requests for permission to reproduce or distribute any part
 *		of, or all of, this work should be mailed to:
 *		
 *		Law Department
 *		TransUnion
 *		555 West Adams
 *		Chicago, Illinois 60661
 *		www.transunion.com
 *		
 ***************************************************************/
package com.tuc.colombiaweb.controller.action;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.tuc.adviser.common.AdviserConstants;
import com.tuc.adviser.dao.AdviserInstanceDao;
import com.tuc.adviser.dto.FilterDto;
import com.tuc.adviser.dto.NamedFilterDto;
import com.tuc.adviser.dto.SearchNamedFilterDto;
import com.tuc.adviser.dto.UserDto;
import com.tuc.adviser.enumeration.NamedFilterGroupType;
import com.tuc.adviserweb.common.AdviserUtils;
import com.tuc.adviserweb.common.ApplicationConstant;
import com.tuc.adviserweb.common.TilesConstants;
import com.tuc.adviserweb.controller.action.ManageNamedFiltersAction;
import com.tuc.adviserweb.controller.form.NamedFilterForm;
import com.tuc.adviserweb.service.FilterService;
import com.tuc.adviserweb.service.LoginService;
import org.owasp.esapi.ESAPI;

@Controller
public class ColombiaManageNamedFiltersAction extends ManageNamedFiltersAction
{
	private static final Logger LOGGER = LogManager.getLogger();

	private static final String BASE_URL = "manageNamedFilter/";
	private static final String VIEW_SELECTED_NAMED_FILTER_URL = BASE_URL + "viewSelectedNamedFilter.do";
	private static final String CHANGE_SELECTED_NAMED_FILTER_URL = BASE_URL + "changeSelectedNamedFilter.do";

	private static final String MODEL = "namedFilterForm";
	@Override
	@RequestMapping(value = "/**/manageNamedFilter.do", method = {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView manageNamedFilter(@ModelAttribute(MODEL) NamedFilterForm namedFilterForm, BindingResult result, HttpServletRequest httpServletRequest)
	{
		LOGGER.debug("inside manageNamedFilter");
		String forward = TilesConstants.TILES_ACTION_ERROR;

		HttpSession httpSession = httpServletRequest.getSession(false);
		String str = httpServletRequest.getParameter("namedFilterIdStrArray");
		try
		{
			LOGGER.debug("request-->namedFilterIdStrArray=[{}]", str);

			if (str != null && "".equals(str.trim()) == false)
				if (httpServletRequest.getParameter("namedFilterIdStrArray") != null && !(httpServletRequest.getParameter("namedFilterIdStrArray").equals("")))
				{
					namedFilterForm.setNamedFilterIdStrArray(str);

					if (str.indexOf(",") != -1)
					{
						String[] tempIdArray = str.split(",");

						namedFilterForm.setNamedFilterIdArray(tempIdArray);
					}
				}
				else
				{
					namedFilterForm.setNamedFilterIdStrArray(null);
					namedFilterForm.setNamedFilterIdArray(null);
				}

			namedFilterForm.setSubmitType(TilesConstants.TILES_ACTION_MANAGE_NAMED_FILTER);

			UserDto userDto = (UserDto)httpSession.getAttribute(ApplicationConstant.SESSION_KEY_USER);
			httpServletRequest.setAttribute("userMembersDtoList", loginService.getAllMembers(userDto));

			// get all named filters

			SearchNamedFilterDto searchNamedFilterDto = new SearchNamedFilterDto();
			List<NamedFilterDto> userNamedFilterDtoList = null;

			if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ADMIN)))
			{
				// get the list of all filters
				userNamedFilterDtoList = filterService.findNamedFilterList(searchNamedFilterDto, userDto);
			}
			else
			{
				// get the list of user members
				searchNamedFilterDto.setWhereFilter(AdviserConstants.SEARCH_MEMBER_CODE);
				searchNamedFilterDto.setMemberCode(userDto.getMemberDto().getMemberCode());
				userNamedFilterDtoList = filterService.getAllNFWithGlobalNF(searchNamedFilterDto);

			}
			LOGGER.debug("Size of userNamedFilterDtoList={}", userNamedFilterDtoList);

			List<FilterDto> list = filterService.getAllFilters();
			LOGGER.debug("Size of filterDtoList={}", list);
			AdviserUtils.sortCompareNamedFilter(userNamedFilterDtoList);
			httpServletRequest.setAttribute("filterDtoList", list);
			httpServletRequest.setAttribute("userNamedFilterDtoList", userNamedFilterDtoList);
			httpServletRequest.setAttribute("templateId", searchNamedFilterDto.getTemplateId());
			forward = TilesConstants.TILES_ACTION_MANAGE_NAMED_FILTER_DEFINITION;

		}
		catch (

		Exception e)
		{
			LOGGER.error("ERROR: occurs while manageNamedFilter - ", e);
		}
		LOGGER.debug("Out manageNamedFilter forward=[{}]", forward);
		return new ModelAndView(forward, "namedFilterForm", namedFilterForm);
	}
     
	@Override
	@RequestMapping(value = "/checkFilterUsed.do", method = {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView checkFilterUsed(HttpServletRequest request, HttpServletResponse response)
	{
		
		return super.checkFilterUsed(request,response);
	}
	@Override
	@RequestMapping(value = "/**/viewNamedFilterDetails.do", method = {RequestMethod.POST, RequestMethod.GET})
	public ModelAndView viewNamedFilterDetails(@ModelAttribute(MODEL) NamedFilterForm namedFilterForm, BindingResult result, HttpServletRequest httpServletRequest)
	{
		LOGGER.debug("In viewNamedFilterDetails action=[{}]", "/viewNamedFilterDetails.do");
		return super.viewNamedFilterDetails(namedFilterForm, result, httpServletRequest);
	}

	@Override
	@RequestMapping("/**/searchNamedFilter.do")
	public ModelAndView searchNamedFilter(@ModelAttribute(MODEL) NamedFilterForm namedFilterForm, BindingResult result, HttpServletRequest httpServletRequest)
	{
		LOGGER.debug("inside searchNamedFilter");
		String forward = TilesConstants.TILES_ACTION_ERROR;

		LOGGER.debug("In searchNamedFilter submittedStartDate=[{}],submittedEndDate=[{}],DayCount=[{}]",
		        namedFilterForm.getCreatedDateFrom(),
		        namedFilterForm.getCreatedDateTo(),
		        namedFilterForm.getDayCount(),
		        namedFilterForm.getMemberCode());

		HttpSession httpSession = httpServletRequest.getSession(false);

		try
		{
			UserDto userDto = (UserDto)httpSession.getAttribute(ApplicationConstant.SESSION_KEY_USER);
			namedFilterForm.setSubmitType(ESAPI.validator().getValidPrintable("Search Named Filter",TilesConstants.TILES_ACTION_SEARCH_NAMED_FILTER, 2000, true));

			SearchNamedFilterDto searchNamedFilterDto = new SearchNamedFilterDto();
			List<NamedFilterDto> userNamedFilterDtoList = null;
			if ((namedFilterForm.getDayCount() != null) && (!namedFilterForm.getDayCount().isEmpty()))
			{

				searchNamedFilterDto.setCreatedDateFromStr((formatter.format(AdviserUtils.getDateWithDateDifference(new Date(), -Integer.parseInt(namedFilterForm.getDayCount())))).toString());
				searchNamedFilterDto.setCreatedDateToStr((formatter.format(new Date())).toString());
			}

			if ((namedFilterForm.getCreatedDateFrom() != null) && (!namedFilterForm.getCreatedDateFrom().isEmpty()))
			{
				searchNamedFilterDto.setCreatedDateFromStr(ESAPI.validator().getValidPrintable("Create Date From",namedFilterForm.getCreatedDateFrom(), 2000, true));
			}

			if ((namedFilterForm.getCreatedDateTo() != null) && (!namedFilterForm.getCreatedDateTo().isEmpty()))
			{
				searchNamedFilterDto.setCreatedDateToStr(ESAPI.validator().getValidPrintable("Create Date To",namedFilterForm.getCreatedDateTo(), 2000, true));
			}

			searchNamedFilterDto.setWhereFilter(ESAPI.validator().getValidInput("Filter",namedFilterForm.getWhereFilter(),"HTTPParameterValue", 2000, true));
			if (namedFilterForm.getFilterGroupName() != null && namedFilterForm.getFilterGroupName()!="")
			{
				searchNamedFilterDto.setFilterGroupName(ESAPI.validator().getValidPrintable("Filter Group Name",namedFilterForm.getFilterGroupName(), 2000, true).trim());
			}
			if (namedFilterForm.getFilterNameId() != null && namedFilterForm.getFilterNameId()!="")
			{
				searchNamedFilterDto.setFilterID(ESAPI.validator().getValidInput("Filter Id",namedFilterForm.getFilterNameId(),"FilterIdFieldValue", 2000, true).trim());
			}
			if (namedFilterForm.getMemberCode() != null && namedFilterForm.getMemberCode()!="")
			{
				searchNamedFilterDto.setMemberCode(getValidInput("MemberCode from form",namedFilterForm.getMemberCode(),"MemberCodeFieldValue", 1000, true).trim());
			}
			searchNamedFilterDto.displayObjectState();
			if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ADMIN)))
			{
				userNamedFilterDtoList = filterService.searchNamedFilter(searchNamedFilterDto, userDto);
			}
			else
			{
				String mCode = userDto.getMemberDto().getMemberCode();
				userNamedFilterDtoList = filterService.searchNamedFilter(searchNamedFilterDto, userDto);
				List<NamedFilterDto> tempNFdtos = new ArrayList<NamedFilterDto>();
				for (NamedFilterDto nfDto : userNamedFilterDtoList)
				{
					if ((!(nfDto.getNamedFilterGroupType().equals(NamedFilterGroupType.GLOBAL)) && (nfDto.getMemberDto().getMemberCode().equals(mCode))) || (nfDto.getNamedFilterGroupType().equals(NamedFilterGroupType.GLOBAL)))
					{
						tempNFdtos.add(nfDto);
					}
				}
				userNamedFilterDtoList = new ArrayList<NamedFilterDto>();
				userNamedFilterDtoList.addAll(tempNFdtos);

			}

			LOGGER.debug("Size of userNamedFilterDtoList={}", userNamedFilterDtoList);
			AdviserUtils.sortCompareNamedFilter(userNamedFilterDtoList);
			httpServletRequest.setAttribute("userNamedFilterDtoList", userNamedFilterDtoList);
			List<FilterDto> list = filterService.getAllFilters();
			LOGGER.debug("Size of filterDtoList={}", list);

			httpServletRequest.setAttribute("filterDtoList", list);
			httpServletRequest.setAttribute("userMembersDtoList", loginService.getAllMembers(userDto));
			httpServletRequest.setAttribute("templateId", ESAPI.validator().getValidInput("Template Id",namedFilterForm.getTemplateId(),"TemplateIdFieldValue", 2000, true));

			forward = TilesConstants.TILES_ACTION_MANAGE_NAMED_FILTERS;
		}
		catch (Exception e)
		{
			LOGGER.error("ERROR: occurs while searchNamedFilter - ", e);
		}
		LOGGER.debug("Out searchNamedFilter forward=[{}]", forward);

		return new ModelAndView(forward, "namedFilterForm", namedFilterForm);
	}

	@Override
	@RequestMapping(value = VIEW_SELECTED_NAMED_FILTER_URL, method = {GET, POST})
	public ModelAndView viewSelectedNamedFilter(@ModelAttribute(MODEL) NamedFilterForm namedFilterForm, BindingResult result, HttpServletRequest httpServletRequest)
	{
		LOGGER.debug("In viewSelectedNamedFilter action=[{}]", VIEW_SELECTED_NAMED_FILTER_URL);
		ModelAndView forward = super.viewSelectedNamedFilter(namedFilterForm, result, httpServletRequest);
		LOGGER.debug("In viewSelectedNamedFilter forward=[{}]", forward);
		return forward;
	}

	@Override
	@RequestMapping(value = CHANGE_SELECTED_NAMED_FILTER_URL, method = {GET, POST})
	public ModelAndView changeSelectedNamedFilter(@ModelAttribute(MODEL) NamedFilterForm namedFilterForm, BindingResult result, HttpServletRequest httpServletRequest)
	{
		LOGGER.debug("In changeSelectedNamedFilter action=[{}]", CHANGE_SELECTED_NAMED_FILTER_URL);
		ModelAndView forward = super.changeSelectedNamedFilter(namedFilterForm, result, httpServletRequest);
		LOGGER.debug("In changeSelectedNamedFilter forward=[{}]", forward);
		return forward;
	}

	@Override
	@Resource
	public void setFilterService(FilterService filterService)
	{
		super.setFilterService(filterService);
	}

	@Override
	@Resource
	public void setLoginService(LoginService loginService)
	{
		super.setLoginService(loginService);
	}

	@Override
	@Resource
	public void setFormatter(SimpleDateFormat formatter)
	{
		super.setFormatter(formatter);
	}

	@Override
	@Resource
	public void setInstanceDao(AdviserInstanceDao instanceDao)
	{
		super.setInstanceDao(instanceDao);
	}

	@Override
	@Resource
	public void setInstanceId(int instanceId)
	{
		super.setInstanceId(instanceId);
	}

}
