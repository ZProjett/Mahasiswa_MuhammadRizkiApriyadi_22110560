<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Proses Hapus</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .result-box {
            max-width: 500px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .result-box h2 {
            color: #0d47a1;
            margin-bottom: 20px;
        }
        .btn-kembali {
            margin-top: 25px;
            background-color: #1976d2;
            color: white;
            padding: 10px 25px;
            border: none;
            font-weight: 500;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-kembali:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<header>
    <div class="logo">🎓 Portal Mahasiswa</div>
    <div class="info-header">🚀 Praktek Java Lanjutan </div>
</header>

<div class="result-box">
<%
    String id = request.getParameter("id");

    if (id == null || id.trim().isEmpty()) {
        response.sendRedirect("lihat.jsp?error=id");
        return;
    }

    int idInt;
    try {
        idInt = Integer.parseInt(id);
    } catch (NumberFormatException e) {
        response.sendRedirect("lihat.jsp?error=id");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crud", "root", "");

        // Cek apakah data ada
        stmt = conn.prepareStatement("SELECT * FROM mahasiswa WHERE id = ?");
        stmt.setInt(1, idInt);
        rs = stmt.executeQuery();
        if (!rs.next()) {
            response.sendRedirect("lihat.jsp?error=notfound");
            return;
        }
        rs.close();
        stmt.close();

        // Proses hapus
        stmt = conn.prepareStatement("DELETE FROM mahasiswa WHERE id = ?");
        stmt.setInt(1, idInt);
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
%>
    <script>
        Swal.fire({
            title: 'Sukses!',
            text: 'Data mahasiswa berhasil dihapus.',
            icon: 'success',
            confirmButtonText: 'OK',
            timer: 2000,
            timerProgressBar: true,
            showClass: {
                popup: 'animate__animated animate__fadeInDown'
            },
            hideClass: {
                popup: 'animate__animated animate__fadeOutUp'
            }
        }).then(() => {
            window.location.href = 'lihat.jsp';
        });
    </script>
<%
        } else {
            response.sendRedirect("lihat.jsp?error=gagal");
            return;
        }

    } catch (Exception e) {
%>
    <h2 style="color: red;">❌ Terjadi error: <%= e.getMessage() %></h2>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
    <a href="lihat.jsp" class="btn-kembali">⬅ Kembali ke Daftar Mahasiswa</a>
</div>

<footer>© 2025 Portal Mahasiswa</footer>

</body>
</html>