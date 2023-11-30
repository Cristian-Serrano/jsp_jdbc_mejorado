<%@page import="java.sql.*" %>
<%@page import="java.util.Objects" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    int numero = -1;
    String tipo = null;
    String ubicacion = null;
    java.util.Date fecha = null;
    //boolean flagValidaNumero = false;
    boolean flagValidaTipo = false;
    boolean flagValidaUbicacion = false;
    boolean flagValidaFecha = false;
    try {
        //numero = Integer.parseInt(request.getParameter("numero"));
        //flagValidaNumero = true;


        //UTILIZO LOS CONTRACTS DE LA CLASE Objects PARA LA VALIDACIÓN
        //             v---- LANZA NullPointerException SI EL PARÁMETRO ES NULL
        Objects.requireNonNull(request.getParameter("tipo"));
        flagValidaTipo = true;
        tipo = request.getParameter("tipo");


        //UTILIZO LOS CONTRACTS DE LA CLASE Objects PARA LA VALIDACIÓN
        //             v---- LANZA NullPointerException SI EL PARÁMETRO ES NULL
        Objects.requireNonNull(request.getParameter("ubicacion"));
        //CONTRACT nonBlank
        //UTILIZO isBlank SOBRE EL PARÁMETRO DE TIPO String PARA CHEQUEAR QUE NO ES UN PARÁMETRO VACÍO "" NI CADENA TODO BLANCOS "    "
        //          |                                EN EL CASO DE QUE SEA BLANCO LO RECIBIDO, LANZO UNA EXCEPCIÓN PARA INVALIDAR EL PROCESO DE VALIDACIÓN
        //          -------------------------v                      v---------------------------------------|
        if (request.getParameter("ubicacion").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaUbicacion = true;
        ubicacion = request.getParameter("ubicacion");


        //UTILIZO LOS CONTRACTS DE LA CLASE Objects PARA LA VALIDACIÓN
        //             v---- LANZA NullPointerException SI EL PARÁMETRO ES NULL
        Objects.requireNonNull(request.getParameter("fecha"));

        var format = new SimpleDateFormat("yyyy-MM-dd");
        fecha = format.parse(request.getParameter("fecha"));
        flagValidaFecha = true;

    } catch (Exception ex) {
        ex.printStackTrace();

        /*if (!flagValidaNumero){
            session.setAttribute("error","Error en número");
        } else*/
        if (!flagValidaTipo){
            session.setAttribute("error","Error en tipo");
        } else if (!flagValidaUbicacion){
            session.setAttribute("error","Error en ubicacion");
        } else if (!flagValidaFecha){
            session.setAttribute("error","Error en fecha");
        }

        valida = false;
    }
    //FIN CÓDIGO DE VALIDACIÓN

    if (valida) {

        Connection conn = null;
        PreparedStatement ps = null;

    	ResultSet rs = null;

        try {
                    //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
            //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto", "root", "user");
            Statement s = conn.createStatement();

            //realizo yo mismo el autoincrement para que no de problemas
            out.println("<p>TRAZA<p>");
            rs = s.executeQuery("SELECT MAX(entrenamientoID) FROM entrenamiento");
            if(rs.next())
            {
                numero = rs.getInt("MAX(entrenamientoID)")+1;
            }

            String sql = "INSERT INTO entrenamiento VALUES ( " +
                    "?, " + //numero
                    "?, " + //tipo
                    "?, " + //ubicacion
                    "?)"; //fecha

            ps = conn.prepareStatement(sql);
            int idx = 1;
            ps.setInt(idx++, numero);
            ps.setString(idx++, tipo);
            ps.setString(idx++, ubicacion);
            ps.setDate(idx++, new java.sql.Date(fecha.getTime()));

            int filasAfectadas = ps.executeUpdate();
            System.out.println("ENTRENAMIENTOS GRABADOS:  " + filasAfectadas);

        } catch (Exception ex) {
            ex.printStackTrace();

        } finally {
            //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
            //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
            try { rs.close(); } catch (Exception e) { /* Ignored */ }
            try {
                ps.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                conn.close();
            } catch (Exception e) { /* Ignored */ }
        }

        out.println("Entrenamiento guardado.");

        session.setAttribute("entrenamientoIDADestacar", numero);
        response.sendRedirect("listadoEntrenamientos.jsp?entrenamientoID="+numero);
    } else {
        out.println("Error de validación!");
        response.sendRedirect("formularioEntrenamiento.jsp");
    }
%>

</body>
</html>
