<%@page language="java" trimDirectiveWhitespaces="true"%>
<%@ page import="com.v2crm.services.UserService" %>
<%@ page import="com.v2crm.domain.User" %>
<%@ page import="com.v2crm.util.SpringUtil" %>
<%@ page import="com.v2crm.exceptions.CRMException" %>


<%

		try{
			String pass = request.getParameter("user-pw");
			String user = request.getParameter("user");
			//System.out.println("here usr is "+user+" pass is "+pass);
				if(user == null || pass == null){
					request.getRequestDispatcher("index.html").forward(request, response);
				}
				else if(user.trim().length() == 0 || pass.trim().length() == 0){
					request.getRequestDispatcher("index.html").forward(request, response);
				}
				else{
					UserService userService = (UserService) SpringUtil.getSpringUtil().getService("userService");
            
					User usr = userService.login(user, pass);
						if(usr == null){
							request.getRequestDispatcher("index.html").forward(request, response);
						}
						else{
							//System.out.println("here usr is "+usr);
							session.setAttribute("loggedIn", usr);
							request.getRequestDispatcher("crm").forward(request, response);
						}
				}
			
			
            	}
            	catch(CRMException e){
            		request.getRequestDispatcher("index.html").forward(request, response);
            	}
%>