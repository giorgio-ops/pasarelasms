package com.analixdata.controladores;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.*;

import com.analixdata.modelos.Servicio;
import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;

public class UsuarioServlet extends HttpServlet {
	
	@Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    String url = null;
	    try {
	      if (SystemProperty.environment.value() ==
	          SystemProperty.Environment.Value.Production) {
	        // Load the class that provides the new "jdbc:google:mysql://" prefix.
	        Class.forName("com.mysql.jdbc.GoogleDriver");
	        url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
	      } else {
	        // Local MySQL instance to use during development.
	        Class.forName("com.mysql.jdbc.Driver");
	        url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";

	        // Alternatively, connect to a Google Cloud SQL instance using:
	        // jdbc:mysql://ip-address-of-google-cloud-sql-instance:3306/guestbook?user=root
	      }
	    } catch (Exception e) {
	      e.printStackTrace();
	      return;
	    }

	    PrintWriter out = resp.getWriter();
	    try {
	      Connection conn = DriverManager.getConnection(url);
	      try {
	    	String id = req.getParameter("identificador");
	        String cedula = req.getParameter("cedula");
	        String nombres = req.getParameter("nombres");
	        String apellidos = req.getParameter("apellidos");
	        String cargo = req.getParameter("cargo");
	        String telefono = req.getParameter("telefono");
	        String email = req.getParameter("email");
	        String password = req.getParameter("passwordUsuario");
	        String estado = req.getParameter("estado");
	        String tipo = req.getParameter("tipo");
	        String empresa = req.getParameter("empresaUsuario");
	        String idtipo=null;
	        String idempresa=null;
	        
	        String inputVerServicios=req.getParameter("verServicios");
	        String btnGuardar=req.getParameter("btnGuardar");
	        
	        ResultSet rs;
	        List<Servicio> servicios= new ArrayList();
	    	  
		     
	    	  
		   
	        
	        
	        System.out.println("clave md5 "+password );
	        
	        rs = conn.createStatement().executeQuery("SELECT idtipo FROM tipo where descripcion ='"+tipo+"';");
        	
        	if(rs.next()){
        		
        		 idtipo=Integer.toString(rs.getInt("idtipo"));
        		 
        	}
        	
            rs = conn.createStatement().executeQuery("SELECT idempresa FROM empresa where nombre ='"+empresa+"';");
        	
        	if(rs.next()){
        		
        		 idempresa=Integer.toString(rs.getInt("idempresa"));
        		 
        	}
        	
        	System.out.println(idtipo+" "+idempresa );
	  
	        
	        if (id == "" || id == null ) {
	        	
	        	
	        	
	        	String statement = "INSERT INTO usuario (cedula,nombres,apellidos,cargo,telefono,email,password,estado,idtipo,idempresa) VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? )";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, cedula);
		          stmt.setString(2, nombres);
		          stmt.setString(3, apellidos);
		          stmt.setString(4, cargo);
		          stmt.setString(5, telefono);
		          stmt.setString(6, email);
		          stmt.setString(7, password);
		          stmt.setString(8, estado);
		          stmt.setString(9, idtipo);
		          stmt.setString(10, idempresa);
		          int success = 2;
		          success = stmt.executeUpdate();
		          if (success == 1) {
		        	  
		        	  	
		        	     
		        		Usuario u = (Usuario)req.getSession().getAttribute("usuario");
		        		
		        		int idnuevo=0;
		        		
		        		rs=conn.createStatement().executeQuery(	"SELECT idusuario FROM pasarelasms.usuario WHERE usuario.email='"+email+"';");
		        		
		        		if(rs.next()){
		        			idnuevo=rs.getInt("idusuario");
		        		}
		        		
		        		
		        		if(u.getTipo().getId() == 2 && idnuevo != 0){
		        			
		        			servicios=u.getServicios();
		        			
		        		       			
		        			for(int i=0; i<servicios.size();i++)
		        			{
		        				
		        				String nomp=servicios.get(i).getDescripcion();
		        				if(req.getParameter(nomp)!=null && req.getParameter(nomp)!=""){
		        					
		        					System.out.println("valor parametro"+nomp);
		        					
		        					statement = "INSERT INTO servicio_usuario (idservicio,idempresa,idusuario) VALUES( ? , ? , ? )";
		        					stmt = conn.prepareStatement(statement);
		        			          stmt.setInt(1, servicios.get(i).getIdServicio());
		        			          stmt.setInt(2, Integer.parseInt(idempresa));
		        			          stmt.setInt(3, idnuevo);
		        			       
		        			          success = 2;
		        			          success = stmt.executeUpdate();
		        				}
		        				
		        				
		        			}
		        			
		        		
		        		}
		        		
		        	  
		            out.println(
		                "<html><head></head><body>Success! Redirecting in 3 seconds...</body></html>");
		          } else if (success == 0) {
		            out.println(
		                "<html><head></head><body>Failure! Please try again! " +
		                "Redirecting in 3 seconds...</body></html>");
		          }
	          
	        } else {
	        	
	        	String statement = "UPDATE usuario SET cedula=?, nombres=?, apellidos=? ,cargo=? ,telefono=? ,email=? , estado=?, idtipo=?, idempresa=? WHERE idusuario=? ";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, cedula);
		          stmt.setString(2, nombres);
		          stmt.setString(3, apellidos);
		          stmt.setString(4, cargo);
		          stmt.setString(5, telefono);
		          stmt.setString(6, email);
		          stmt.setString(7, estado);
		          stmt.setString(8, idtipo);
		          stmt.setString(9, idempresa);
		          stmt.setString(10, id);
		          int success = 2;
		          
		          System.out.println(cedula+" "+nombres+" "+apellidos+" "+cargo+" "+telefono+" "+email+" "+estado+" "+id );
		          System.out.println(statement);
		          
		          success = stmt.executeUpdate();
		          if (success == 1) {
		            out.println(
		                "<html><head></head><body>Success! Redirecting in 3 seconds...</body></html>");
		          } else if (success == 0) {
		            out.println(
		                "<html><head></head><body>Failure! Please try again! " +
		                "Redirecting in 3 seconds...</body></html>");
		          }
	          
	        
	        }
	      } finally {
	        conn.close();
	      }
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	    resp.sendRedirect("/usuarios.jsp");
	  }

}
