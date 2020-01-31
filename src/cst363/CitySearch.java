package cst363;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CitySearch")
public class CitySearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	//database URL
	static final String DB_URL = "jdbc:mysql://localhost/world";
	
	//Database Credentials
	static final String USER = "root";
	static final String PASS = //removed password
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		// SQL Statements
		/*String sql = "SELECT city.ID, city.name, city.population "
				+ "FROM country JOIN city "
				+ "ON country.Code = city.CountryCode "
				+ "WHERE country.name = ?";*/
		
		String sql = "SELECT ID,name,population\r\n" + 
					 "FROM city\r\n" + 
					 "WHERE CountryCode = (SELECT Code FROM country WHERE name = ?)\r\n" + 
					 "order by name";
		
		// Set response content type
		response.setContentType("Text/html");
		PrintWriter out = response.getWriter();
		
		// Get input from form
		String country_name = request.getParameter("country_name");
		
		try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)){
			
			//Prepare Select
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,country_name);
			ResultSet rs = pstmt.executeQuery();
			
			//Start html output
			out.println("<!DOCTYPE HTML><html><body>");
			
			out.println("<p>Country: "+ country_name + "</p>\n");
			//City Table Headers
			out.println("<table>");
			out.println("<tr>");
			out.println("<th>City ID</th>");
			out.println("<th>City Name</th>");
			out.println("<th>Population</th>");
			
			// creates rows with data for each row from the result set
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("ID") + "</td>");
				out.println("<td>" + rs.getString("name") + "</td>");
				out.println("<td>" + rs.getInt("population") + "</td>");
				out.println("</tr>");
			}
			rs.close();
			
			//end of table
			out.println("</table>");
			out.println("</body></html>");
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
