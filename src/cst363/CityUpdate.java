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

@WebServlet("/CityUpdate")
public class CityUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	// database URL
	static final String DB_URL = "jdbc:mysql://localhost/WORLD";

	// Database credentials.  COMPLETE THE FOLLOWING STATEMENTS
	static final String USER = "root";
	static final String PASS =  "@DevDan2020";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// SQL statements  COMPLETE THE STATEMENTS 
		String sql = "SELECT id, city.name, country.name, city.population FROM city JOIN country ON city.CountryCode = country.Code WHERE id = ?";
		String usql = "UPDATE city SET population = ? WHERE id = ? AND CountryCode = (SELECT code FROM country WHERE name = ?)";

		response.setContentType("text/html"); // Set response content type
		PrintWriter out = response.getWriter();

		try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
			conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
			conn.setAutoCommit(false); 
			
			// get data from form and convert to integer values  
      // COMPLETE THE STATEMENTS with input tag NAMES
			int new_pop = Integer.parseInt(request.getParameter("new_pop"));
			int city_id = Integer.parseInt(request.getParameter("city_id"));
			String country = request.getParameter("country_name");

			// prepare sql select
			PreparedStatement pstmt =  conn.prepareStatement(usql);
      // SET VALUES FOR PARAMETER MARKERS 
			pstmt.setInt(1, new_pop);
			pstmt.setInt(2, city_id);
			pstmt.setString(3, country);
			int row_count = pstmt.executeUpdate();

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, city_id);
			ResultSet rs = pstmt.executeQuery();

			out.println("<!DOCTYPE HTML><html><body>");
			out.println("<p>Rows updated = " + row_count + "</p>");
			out.println("<table> <tr><th>City ID</th><th>City Name</th> <th>Country Name</th> <th>New Population</th></tr>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getInt(1) + "</td>");
				out.println("<td>" + rs.getString(2) + "</td>");
				out.println("<td>" + rs.getString(3) + "</td>");
				out.println("<td>" + rs.getInt(4) + "</td>");
				out.println("</tr>");
			}
			rs.close();
			out.println("</table>");
			out.println("</body></html>");
			conn.commit();
		} catch (SQLException e) {
			// Handle errors
			e.printStackTrace();
		}  
	}

}
