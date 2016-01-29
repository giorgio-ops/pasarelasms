<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.analixdata.modelos.Servicio" %>

<html>
<HEAD>

	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">
	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<SCRIPT type=text/javascript>
	
	
	$(function() {
	    $('#empresa').on('change', function(event) {
	    	document.getElementById("btnContinuar").click();
	    });
	});
	
		
		
	</SCRIPT> 
   </HEAD>

  <body>

<%

//allow access only if session exists

session = request.getSession();
	Usuario us = (Usuario)session.getAttribute("usuario");
	
	if (us==null)
	{
		
		session.setAttribute("error", "error");
		response.sendRedirect("/login.jsp");
	}
String userName = null;
String sessionID = null;
Cookie[] cookies = request.getCookies();
if(cookies !=null){
for(Cookie cookie : cookies){
if(cookie.getName().equals("usuario")) 
	userName = cookie.getValue();
}
}


String url = null;
if (SystemProperty.environment.value() ==
    SystemProperty.Environment.Value.Production) {
  // Load the class that provides the new "jdbc:google:mysql://" prefix.
  Class.forName("com.mysql.jdbc.GoogleDriver");
  url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
} else {
  // Local MySQL instance to use during development.
  Class.forName("com.mysql.jdbc.Driver");
  url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";
}

Connection conn = DriverManager.getConnection(url);
ResultSet rs = conn.createStatement().executeQuery(
    "SELECT * FROM empresa WHERE estado=1");
%>


<nav class="navbar" >
  	<div class="container-fluid">
		<div class="navbar-header">
			<a href="index.jsp"><img class="logo" src="imagenes/logo-analix-data.png"/></a>
		</div>  
		
		<div class="navbar-nav navbar-right">
			<a href="/cerrarSesion"><button type="button" class="btn btn-lg btn-default cerrarsesion">Cerrar sesión <span class="glyphicon glyphicon-log-out"></span></button></a>
		</div>
		<div class="navbar-nav navbar-right ">
			<h4 class="msgbienvenida">Bienvenido usuario <%= userName %></h4>
		</div>
		
	</div>	
  	</nav>
  	<div class="container-fluid">
	  	<div class="row">
			  	<div class="col-sm-3 col-md-2 sidebar"> 
				    <ul class="nav nav-sidebar">
						<li><a href="empresas.jsp">Empresas</a></li>
						<li ><a href="servicios.jsp">Servicios</a></li>
						<li><a href="usuarios.jsp">Usuarios</a></li>
						
						<%  
							if(u != null){
								
								int tipo=u.getTipo().getId();
								
								if(tipo == 1){ 
								%>
									<li><a href="empresas.jsp">Empresas</a></li>
									<li ><a href="servicios.jsp">Servicios</a></li>
									<li><a href="usuarios.jsp">Usuarios</a></li>
									<li ><a href="servicioEmpresa.jsp">Servcios a empresas</a></li>
									<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
								<%}
								
								if(tipo == 2){ 
									%>
										<li><a href="empresas.jsp">Empresa</a></li>
										<li ><a href="servicios.jsp">Servicios</a></li>
										<li><a href="usuarios.jsp">Usuarios</a></li>
										<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
									<%}
								
								if(tipo == 3){ 
									%>
										<li><a href="empresas.jsp">Empresa</a></li>
										<li ><a href="servicios.jsp">Servicios</a></li>
										<li><a href="usuarios.jsp">Usuario</a></li>
								
									<%}
								
							}
						%>
						
						<li><a href="mensajeria.jsp">Mensajería.</a></li>
						<li><a href="mensajeria.jsp">Reportes.</a></li>
						<li><a href="/cerrarSesion">Cerrar Sesión.</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Asignación de Servicios a Usuarios</h1>
				<form  action="/asignarServicioUsuario">

				<div>Seleccione una empresa:
					<select name=empresa id="empresa" > 
					<% 
					while (rs.next()) {
					String empresa = rs.getString("nombre");
					
					if(!(session.getAttribute("empresa") == null)){
							
							if(empresa.equals(session.getAttribute("empresa"))){%>
								<option value=<%= empresa %> selected ><%= empresa %></option>
							<%}else{%>
							<option value=<%= empresa %>><%= empresa %></option>
					<%	
							}
						}else{%>
						<option value=<%= empresa %>><%= empresa %></option>
					<%}}
					%>
					</select><input type="submit" value="Continuar" name="btnContinuar" id="btnContinuar"/>
					</div>
				
					<%
						
					
						if(!(session.getAttribute("listaUsuarios") == null)){
							
						List<Usuario> lista= (List<Usuario>)session.getAttribute("listaUsuarios");
						
					%>
							<div>Seleccione un usuario:
							<select name=usuario id="usuario">
								<% 
								for( Usuario u:lista) {
								%>
									<option value=<%= u.getId() %>><%= u.getNombres() %></option>
								<%
									}
								%>
				    		</select> 
							
					<% 	
						}
					%>	
					</div>
					
					<%
						if(!(session.getAttribute("listaServicios") == null)){
							
						List<Servicio> listaS= (List<Servicio>)session.getAttribute("listaServicios");
						
					%>
							<div>Seleccione un servicio:
							<select name=servicio id="servicio">
								<% 
								for( Servicio ser:listaS) {
								%>
									<option value=<%= ser.getIdServicio() %>><%= ser.getDescripcion() %></option>
								<%
									}
								%>
				    		</select> 
							
					<% 	
						}
					%>	
					</div>
				    
				    
				
				<div><input type="submit" value="Guardar" name="btnGuardar"/> </div>
					<%
				
						conn.close();
						
						if(!(session.getAttribute("confirmacion") == null)){
							if(session.getAttribute("confirmacion") == "1"){
							%>
								<div><h3>Servicio asignado exitosamente.</h3></div>
							<%
							}
							}
					
					%>
				
				
				  </form>
			</div>	
	
		</div>
	</div>
	




  </body>
</html>