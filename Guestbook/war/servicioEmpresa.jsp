<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>

<html>
<HEAD>
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">

	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<SCRIPT type=text/javascript>
	
			function obtenerDatos(el) {
				document.getElementById("idServicio").value= el.parentNode.parentNode.cells[0].textContent;
			document.getElementById("servicio").value= el.parentNode.parentNode.cells[1].textContent;
			document.getElementById("empresa").value = el.parentNode.parentNode.cells[2].textContent;
			document.getElementById("limite").value = el.parentNode.parentNode.cells[3].textContent;
			document.getElementById("costo").value = el.parentNode.parentNode.cells[4].textContent;

			if(el.parentNode.parentNode.cells[8].textContent == "Activo")
			 	document.getElementById("estado").value = 1 ;
			else
				document.getElementById("estado").value = 0 ;
			}
			
			function validar(){
				
				if(document.getElementById("empresa").value =="noempresa" && document.getElementById("servicio").value =="noservicio" ){
					
					alert("No hay información suficiente para continuar. Revise sus selecciones.");
				}
				
			}
		
		
	</SCRIPT> 
   </HEAD>

  <body>

<%

//allow access only if session exists

session = request.getSession();
	Usuario u = (Usuario)session.getAttribute("usuario");
	
	if (u==null)
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
    "SELECT servicio_empresa.idservicio,descripcion,nombre,limite,costotransaccion,servicio_empresa.estado FROM pasarelasms.servicio_empresa,pasarelasms.servicio,pasarelasms.empresa WHERE servicio_empresa.idservicio=servicio.idservicio and servicio_empresa.idempresa=empresa.idempresa and empresa.estado=1;");
%>


  	<nav class="navbar" >
  	<div class="container-fluid">
		<div class="navbar-header">
			<a href="index.jsp"><img class="logo" src="imagenes/logo-analix-data.png"/></a>
		</div>  
		
		<div class="navbar-nav navbar-right">
			<a href="/cerrarSesion" class="cerrarsesion"><img class="imglogout" src="imagenes/imglogout.png"/></button></a>
		</div>
		<div class="navbar-nav navbar-right ">
			<h4 class="msgbienvenida">Bienvenido usuario <%= userName %><img class="icousuario" src="imagenes/icousuario.png"/></h4>
			 
		</div>
		
	</div>	
  	</nav>
  	<div class="container-fluid">
	  	<div class="row">
			  	<div class="col-sm-3 col-md-2 sidebar"> 
				    <ul class="nav nav-sidebar">
							<%  
						if(u != null){
							
							int tipo=u.getTipo().getId();
							
							if(tipo == 1){ 
							%>
								<li><a href="empresas.jsp"><h5><img class="icomenu" src="imagenes/icoempresa.png"/>Empresas</h5></a></li>
								<li ><a href="servicios.jsp"><h5><img class="icomenu" src="imagenes/icoservicios.png"/>Servicios</h5></a></li>
								<li><a href="usuarios.jsp"><h5><img class="icomenu" src="imagenes/icousuarios.png"/>Usuarios</h5></a></li>
								<li ><a href="servicioEmpresa.jsp"><h5>Servicios a empresas</h5></a></li>
								<li><a href="servicioUsuarios.jsp"><h5>Servicios a Usuarios</h5></a></li>
									
									<li><a href="mensajeria.jsp"><h5><img class="icomenu" src="imagenes/icomensajeria.png"/>Mensajería</h5></a></li>
									<li><a href="reportes.jsp"><h5><img class="icomenu" src="imagenes/icoreportes.png"/>Reportes</h5></a></li>
									
								<%}
							
							
							if(tipo == 2){ 
								%>
									<li><a href="empresa.jsp"><h5><img class="icomenu" src="imagenes/icoempresa.png"/>Empresa</h5></a></li>
									<li ><a href="serviciosContratados.jsp"><h5><img class="icomenu" src="imagenes/icoservicios.png"/>Servicios</h5></a></li>
									<li><a href="usuarios.jsp"><h5><img class="icomenu" src="imagenes/icousuarios.png"/>Usuarios</h5></a></li>
									<li><a href="servicioUEmpresa.jsp">Servicios a Usuarios</a></li>
									<%if( u.tieneServicio(1)){
										%>
									<li><a href="mensajeria.jsp"><h5><img class="icomenu" src="imagenes/icomensajeria.png"/>Mensajería</h5></a></li>
									<li><a href="reportesEmpresas.jsp"><h5><img class="icomenu" src="imagenes/icoreportes.png"/>Reportes</h5></a></li>
									
									<%}
								}
							
							if(tipo == 3){ 
								%>
									<li><a href="empresa.jsp"><h5><img class="icomenu" src="imagenes/icoempresa.png"/>Empresa</h5></a></li>
									<li ><a href="serviciosContratados.jsp"><h5><img class="icomenu" src="imagenes/icoservicios.png"/>Servicios</h5></a></li>
									<li><a href="usuario.jsp"><h5><img class="icomenu" src="imagenes/icousuarios.png"/>Usuario</h5></a></li>
							
								<%
								
								if( u.tieneServicio(1)){
									%>
									
									<li><a href="mensajeria.jsp"><h5><img class="icomenu" src="imagenes/icomensajeria.png"/>Mensajería</h5></a></li>
									<li><a href="reportesUsuarios.jsp"><h5><img class="icomenu" src="imagenes/icoreportes.png"/>Reportes</h5></a></li>
									
									<%}
							}
							
							
						
						
						%>
						
						
						
						<li><a href="/cerrarSesion"><img class="icomenu" src="imagenes/icocerrar.png"/>Cerrar Sesión</a></li>
								
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Asignación de Servicios a Empresas</h1>
				<table style="border: 1px solid black" id="datosUsuarios">
				<tbody>
				<tr>
				<th style="background-color: #CCFFCC; margin: 5px">ID Servicio</th>
				<th style="background-color: #CCFFCC; margin: 5px">Descripción</th>
				<th style="background-color: #CCFFCC; margin: 5px">Empresa</th>
				<th style="background-color: #CCFFCC; margin: 5px">Límite mensual</th>
				<th style="background-color: #CCFFCC; margin: 5px">Costo / Transacción</th>
				<th style="background-color: #CCFFCC; margin: 5px">Estado</th>
				</tr>
				
				<%
				while (rs.next()) {
				    int id =rs.getInt("idservicio");
					String servicio = rs.getString("descripcion");
				    String empresa = rs.getString("nombre");
				    int limite = rs.getInt("limite");
				    float costo = rs.getFloat("costotransaccion");
				    int estado = rs.getInt("estado"); 
				    String est="";
				    if(estado==1)est="Activo";else est="Inactivo";
				   
				 %>
				<tr>
					<td><%= id %></td>
					<td><%= servicio %></td>
					<td><%= empresa %></td>
					<td><%= limite %></td>
					<td><%= costo %></td>
					<td><%= est %></td>
					<td><button class="btnEditar" type="button" onclick="obtenerDatos(this);" >Editar</button></td>
				</tr>
				<%
				}
				
				rs = conn.createStatement().executeQuery("SELECT * FROM servicio");%>
				
				
				
				</tbody>
				</table>
				
				<p><strong>ASGINAR NUEVO SERVICIO A EMPRESAS</strong></p>
				<form action="/asignarServicio" method="post" onsubmit="validar()">
					 <div><input type="hidden" name="idServicio" id="idServicio" required="required"></input></div>
				   
										
					<%ResultSet rs1 = conn.createStatement().executeQuery("SELECT * FROM empresa where estado=1");%>
					
					
					<div>Empresa:
					<select name=empresa id="empresa">
					<option value="noempresa">Seleccionar...</option>
					<% 
					while (rs1.next()) {
					String empresa = rs1.getString("nombre");%>
						<option value=<%= empresa %>><%= empresa %></option>
					<%}%>
					</select>
					</div>
					
					<div>Servicio:
				    	<select name=servicio id="servicio">
				    	<option value="noservicio">Seleccionar...</option>
				    		<% 
					while (rs.next()) {
					String descServicio = rs.getString("descripcion");%>
						<option value=<%= descServicio %>><%= descServicio %></option>
					<%}%>
				    		</select> 
					</div>
					
				    <div>Límite mensual: <input type="number" name="limite" id="limite" required="required"></input></div>
				    <div>Precio por Transacción: <input type="text" name="costo" id="costo" required="required"></input></div>
				    <div>Estado:
				    	<select name=estado id="estado">
				    		<option seleted value=1>Activo</option>
				    		<option value=0>Inactivo</option>
				    		</select> 
					</div>
					
				    
					<%
					conn.close();
					%>
					
				    <div><input type="submit" value="Guardar"/>
				    <input type="reset" value="Cancelar"/></div>
				  </form>
			</div>	
	
		</div>
	</div>
	<footer class="footer">
      <div class="container" style="margin-left:25px;margin-right:-25px;">
      	 <div class="footizquierda">Analixdata, 2015 | Copyright © 2016. Todos los derechos reservados.</div>
       	  <div class="footderecha">Teléfono: 593 07 3701919   Email: lalvarez@analixdata.com<img class="icoheader" style="margin-left:10px;" src="imagenes/icogoogle.png"/> <img class="icoheader" src="imagenes/icotwitter.png"/> <a href="https://www.facebook.com/AnalixData-Cia-Ltda-1053799024633059/?fref=ts" target="_blank"><img class="icoheader" src="imagenes/icofacebook.png"/></a></div>
    
      </div>
    </footer>
<%} %>

  </body>
</html>