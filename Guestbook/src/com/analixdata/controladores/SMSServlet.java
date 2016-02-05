package com.analixdata.controladores;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;
import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author geova
 */
public class SMSServlet extends HttpServlet {

	@Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		
		String urlEnvio = "http://9-dot-pasarelasms-1190.appspot.com/APIAnalix?idempresa=1&usuario=alina&pass=1234";
		
		URL obj = new URL(urlEnvio);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setReadTimeout(60 * 1000);
        con.setConnectTimeout(60 * 1000);
		// optional default is GET
		con.setRequestMethod("GET");

		//con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0");
		//con.setRequestProperty ("Authorization", "Basic REM1NjIzMTVCM0NCOUVGOjA2MzZFM0FGMTQ=");
		int responseCode = con.getResponseCode();
		System.out.println("\nSending 'GET' request to URL : " + urlEnvio);
		System.out.println("Response Code : " + responseCode);
		
		PrintWriter out = resp.getWriter();

		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		out.println( in);
		
		String inputLine;
		StringBuffer response = new StringBuffer();
		
		while ((inputLine = in.readLine()) != null)
		{
			response.append(inputLine);
		}
		in.close();

        if (responseCode == 200)    	
    	    out.println( ""+inputLine );


	  }


}