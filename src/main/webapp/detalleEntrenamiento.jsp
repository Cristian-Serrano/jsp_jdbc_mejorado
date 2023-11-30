<%@page import="java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Detalle socio</title>
</head>
<body>
<%
    ResultSet rs = null;
    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    int id = -1;
    try {
        id = Integer.parseInt(request.getParameter("entrenamientoID"));
    } catch (NumberFormatException nfe) {
        nfe.printStackTrace();
        valida = false;
    }
    //FIN CÓDIGO DE VALIDACIÓN


    if (valida) {


        id = Integer.parseInt(request.getParameter("entrenamientoID"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto", "root", "user");


            String sql = "select * from entrenamiento where entrenamientoID = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            rs = ps.executeQuery();
            if (rs.next())
            {
                int entrenamiento = rs.getInt("entrenamientoID");
                String tipo = rs.getString("tipo");
                String ubicacion = rs.getString("ubicacion");
                Date fecha = rs.getDate("fecha");
%>
<h1>Detalle entrenamiento</h1>
<p>ID del entrenamiento: <%= entrenamiento %></p>
<p>Tipo: <%= tipo %></p>
<p>Ubicacion: <%= ubicacion %></p>
<p>Fecha: <%= fecha %></p>
<%
            }


        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
            //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
            try {
                rs.close();
            } catch (Exception e) {
                /* Ignored */
            }
            try {
                ps.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                conn.close();
            } catch (Exception e) { /* Ignored */ }
        }
    }else{
        response.sendRedirect("listadoEntrenamientos.jsp");
    }
%>
<a href="index.jsp">Volver</a>
</body>
</html>