package com.tuc.adviserweb.controller.action;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.tuc.adviser.dao.AdviserInstanceDao;
import com.tuc.adviser.dto.AdviserInstanceDto;
import com.tuc.adviser.dto.FilterDto;
import com.tuc.adviser.dto.MemberDto;
import com.tuc.adviser.dto.NamedFilterDto;
import com.tuc.adviser.dto.UserDto;
import com.tuc.adviser.enumeration.NamedFilterGroupType;
import com.tuc.adviserweb.common.ApplicationConstant;
import com.tuc.adviserweb.common.TilesConstants;
import com.tuc.adviserweb.controller.form.NamedFilterForm;
import com.tuc.adviserweb.service.FilterService;
import com.tuc.adviserweb.service.LoginService;
import org.owasp.esapi.ESAPI;

public class CreateNamedFilterAction
{
	private static final Logger logger = LogManager.getLogger();
	protected FilterService filterService;
	protected LoginService loginService;
	protected AdviserInstanceDao instanceDao;
	protected List<String> lstfiltrtype = new ArrayList<String>();
	protected int instanceId;

	public ModelAndView createNamedFilter(@ModelAttribute("namedFilterForm") NamedFilterForm namedFilterForm, HttpServletRequest httpServletRequest)
	{
		logger.debug("inside createNamedFilter action");
		HttpSession httpSession = httpServletRequest.getSession(false);
		String forward = TilesConstants.TILES_ACTION_ERROR;

		try
		{
			UserDto userDto = (UserDto)httpSession.getAttribute(ApplicationConstant.SESSION_KEY_USER);
			if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ADMIN)))
			{
				httpServletRequest.setAttribute("userMembersDtoList", loginService.getAllMembers());
				httpServletRequest.setAttribute("lstfiltrtype", lstfiltrtype);
			}
			else if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ANALYST)))
			{
				httpServletRequest.setAttribute("lstfiltrtype", lstfiltrtype);
			}
			forward = TilesConstants.TILES_ACTION_CREATE_NAMED_FILTER;
			//namedFilterForm.setTemplateId(httpServletRequest.getParameter("templateId"));
			namedFilterForm.setTemplateId(ESAPI.httpUtilities().getParameter(httpServletRequest, "templateId"));
			httpServletRequest.setAttribute("templateId", namedFilterForm.getTemplateId());
		}
		catch (Exception e)
		{
			logger.error("ERROR: occurs while create named filter - ", e);
		}
		logger.debug("Out create named filter forward=[{}]", forward);
		return new ModelAndView(forward, "namedFilterForm", namedFilterForm);
	}

	public ModelAndView saveNamedFilter(@ModelAttribute("namedFilterForm") NamedFilterForm namedFilterForm,
	        BindingResult result,
	        RedirectAttributes attribute,
	        HttpServletRequest httpServletRequest,
	        HttpServletResponse httpServletResponse)
	{
		logger.debug("inside saveNamedFilter");
		String forward = TilesConstants.TILES_ACTION_ERROR;

		HttpSession httpSession = httpServletRequest.getSession(false);
		UserDto userDto = (UserDto)httpSession.getAttribute(ApplicationConstant.SESSION_KEY_USER);

		try
		{
			NamedFilterDto namedFilterDto = new NamedFilterDto();
			namedFilterDto.setNamedFilterName(namedFilterForm.getNamedFilterName().toUpperCase().trim());
			namedFilterDto.setCreatedOn(new Date());

			if (NamedFilterGroupType.PUBLIC.equals(NamedFilterGroupType.valueOf(namedFilterForm.getType())))
			{
				namedFilterDto.setNamedFilterGroupType(NamedFilterGroupType.PUBLIC);
			}
			else if (NamedFilterGroupType.GLOBAL.equals(NamedFilterGroupType.valueOf(namedFilterForm.getType())))
			{
				namedFilterDto.setNamedFilterGroupType(NamedFilterGroupType.GLOBAL);
			}
			else if (NamedFilterGroupType.PRIVATE.equals(NamedFilterGroupType.valueOf(namedFilterForm.getType())))
			{
				namedFilterDto.setNamedFilterGroupType(NamedFilterGroupType.PRIVATE);
			}

			// need to be clarify wheathe filter are membercode specific or user
			// specific
			if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ADMIN)))
			{
				MemberDto memberDto = new MemberDto();
				memberDto.setMemberCode(namedFilterForm.getMemberCode());
				namedFilterDto.setMemberDto(memberDto);
				namedFilterDto.setFilterGrpType(namedFilterForm.getFiltergrpType());

			}
			else if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ANALYST)))
			{
				namedFilterDto.setMemberDto(userDto.getMemberDto());
				namedFilterDto.setFilterGrpType(namedFilterForm.getFiltergrpType());
			}
			else
			{
				namedFilterDto.setMemberDto(userDto.getMemberDto());
			}
			// namedFilterDto.setTemplateID(Long.valueOf(namedFilterForm.getTemplateId()));
			AdviserInstanceDto instanceDto = instanceDao.getInstanceById(instanceId);
			if (instanceDto != null)
			{
				namedFilterDto.setSerialNumber(((AdviserInstanceDto)instanceDto).getSerialNumber());
			}
			String filePresent = filterService.checkNamedFilterExist(namedFilterDto);
			logger.debug("filePresent [{}]", filePresent);
			if (filePresent != null)
			{
				if ("JsonFilePresent".equalsIgnoreCase(filePresent))
				{
					httpServletRequest.setAttribute("Type", "JsonError");
				}
				else if ("ArchFilePresent".equalsIgnoreCase(filePresent))
				{
					httpServletRequest.setAttribute("Type", "ArchError");
				}
				else
				{
					httpServletRequest.setAttribute("Type", "withError");
				}
				httpServletRequest.setAttribute("message", "errMsgGeneral");
				namedFilterForm.setNamedFilterName("");
				if (userDto.getUserTypeStr().equals((ApplicationConstant.USER_TYPE_ADMIN)))
				{
					httpServletRequest.setAttribute("userMembersDtoList", loginService.getAllMembers(userDto));
				}
				httpServletRequest.setAttribute("lstfiltrtype", lstfiltrtype);
				httpServletRequest.setAttribute("namedFilterForm", namedFilterForm);
				return new ModelAndView(TilesConstants.TILES_ACTION_CREATE_NAMED_FILTER, "namedFilterForm", namedFilterForm);
			}
			else
			{
				filterService.saveOrUpdateNamedFilter(namedFilterDto);
				namedFilterDtoToForm(namedFilterDto, namedFilterForm);
				forward = TilesConstants.TILES_ACTION_REDIRECT + TilesConstants.TILES_ACTION_VIEW_NAMED_FILTER_DETAILS + TilesConstants.TILES_ACTION_EXTENTION;
				forward = forward + "?namedFilterId=" + namedFilterDto.getNamedFilterID();
				return new ModelAndView(forward);
			}
		}
		catch (Exception e)
		{
			logger.error("ERROR: occurs while save named filter - ", e);
		}
		logger.debug("Out save named filter forward=[{}]", forward);
		return new ModelAndView(forward, "namedFilterForm", namedFilterForm);
	}

	public ModelAndView saveFilter(@ModelAttribute("namedFilterForm") NamedFilterForm namedFilterForm, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse)
	{
		logger.debug("inside saveFilter");
		String forward = TilesConstants.TILES_ACTION_ERROR;
		try
		{
			formToNamedFilterDto(namedFilterForm);

			// call Dao method here to save
			// call Dao method here to get namedFilterDto having list of
			// filterdto

			forward = TilesConstants.TILES_ACTION_CREATE_NAMED_FILTER;
		}
		catch (Exception e)
		{
			logger.error("ERROR: occurs while save filter - ", e);
		}
		logger.debug("Out save filter forward=[{}]", forward);
		return new ModelAndView(forward, "namedFilterForm", namedFilterForm);
	}

	protected NamedFilterDto formToNamedFilterDto(NamedFilterForm namedFilterForm)
	{
		NamedFilterDto namedFilterDto = new NamedFilterDto();
		namedFilterDto.setNamedFilterID(Long.valueOf(namedFilterForm.getNamedFilterId()));

		if (namedFilterForm.getFilterId() != null && !namedFilterForm.getFilterId().equals(""))
		{
			List<FilterDto> lstFilters = new ArrayList<FilterDto>();
			FilterDto filterDto = new FilterDto();
			filterDto.setFilterID(Integer.parseInt(namedFilterForm.getFilterId()));
			lstFilters.add(filterDto);
			namedFilterDto.setLstFilters(lstFilters);
		}

		return namedFilterDto;
	}

	protected void namedFilterDtoToForm(NamedFilterDto namedFilterDto, NamedFilterForm namedFilterForm)
	{
		namedFilterForm.setNamedFilterId("" + namedFilterDto.getNamedFilterID());
		namedFilterForm.setNamedFilterName(namedFilterDto.getNamedFilterName().trim());
		namedFilterForm.setMemberCode(namedFilterDto.getMemberDto().getMemberCode());
	}

	/**
	 * @return the filterService
	 */
	public FilterService getFilterService()
	{
		return filterService;
	}

	/**
	 * @param filterService
	 *            the filterService to set
	 */
	public void setFilterService(FilterService filterService)
	{
		this.filterService = filterService;
	}

	/**
	 * @return the loginService
	 */
	public LoginService getLoginService()
	{
		return loginService;
	}

	/**
	 * @param loginService
	 *            the loginService to set
	 */
	public void setLoginService(LoginService loginService)
	{
		this.loginService = loginService;
	}

	public List<String> getLstfiltrtype()
	{
		return lstfiltrtype;
	}

	public void setLstfiltrtype(List<String> lstfiltrtype)
	{
		this.lstfiltrtype = lstfiltrtype;
	}

	public void setInstanceDao(AdviserInstanceDao instanceDao)
	{
		this.instanceDao = instanceDao;
	}

	public void setInstanceId(int instanceId)
	{
		this.instanceId = instanceId;
	}

}
