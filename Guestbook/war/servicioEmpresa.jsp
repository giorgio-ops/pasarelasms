<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>

<html>
<HEAD>

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
		
		
	</SCRIPT> 
   </HEAD>

  <body>

<%
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

rs = conn.createStatement().executeQuery("SELECT * FROM servicio WHERE estado=1");%>



</tbody>
</table>

<p><strong>SERVICIOS ASIGNADOS A EMPRESAS</strong></p>
<form action="/asignarServicio" method="post">
	 <div><input type="hidden" name="idServicio" id="idServicio" required="required"></input></div>
   
	<div>Servicio:
    	<select name=servicio id="servicio">
    		<% 
	while (rs.next()) {
	String descServicio = rs.getString("descripcion");%>
		<option value=<%= descServicio %>><%= descServicio %></option>
	<%}%>
    		</select> 
	</div>
	
	<%rs = conn.createStatement().executeQuery("SELECT * FROM empresa where estado=1");%>
	
	
	<div>Empresa:
	<select name=empresa id="empresa">
	<% 
	while (rs.next()) {
	String empresa = rs.getString("nombre");%>
		<option value=<%= empresa %>><%= empresa %></option>
	<%}%>
	</select>
	</div>
	
    <div>Límite mensual: <input type="number" name="limite" id="limite" required="required"></input></div>
    <div>Costo por Transacción: <input type="text" name="costo" id="costo" required="required"></input></div>
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
  </body>
</html>