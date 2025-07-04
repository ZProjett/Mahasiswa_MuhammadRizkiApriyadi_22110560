<%@ page import="crud.Mahasiswa" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Proses Tambah</title>
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
    String nim = request.getParameter("nim");
    String nama = request.getParameter("nama");
    String nilaiStr = request.getParameter("nilai");

    if (nim == null || !nim.matches("\\d{8}")) {
        response.sendRedirect("tambah.jsp?error=nim");
        return;
    }

    if (nama == null || nama.trim().isEmpty()) {
        response.sendRedirect("tambah.jsp?error=nama");
        return;
    }

    int nilai;
    try {
        nilai = Integer.parseInt(nilaiStr);
        if (nilai < 0 || nilai > 100) {
            response.sendRedirect("tambah.jsp?error=nilai");
            return;
        }
    } catch (Exception e) {
        response.sendRedirect("tambah.jsp?error=nilai");
        return;
    }

    Mahasiswa mhs = new Mahasiswa();
    mhs.nim = nim;
    mhs.nama = nama;
    mhs.nilai = nilai;

    java.sql.Connection conn = null;
    java.sql.PreparedStatement stmt = null;
    java.sql.ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/crud", "root", "");

        // Cek nama
        stmt = conn.prepareStatement("SELECT * FROM mahasiswa WHERE nama = ?");
        stmt.setString(1, nama);
        rs = stmt.executeQuery();
        if (rs.next()) {
            response.sendRedirect("tambah.jsp?error=nama");
            return;
        }
        rs.close();
        stmt.close();

        // Cek NIM
        stmt = conn.prepareStatement("SELECT * FROM mahasiswa WHERE nim = ?");
        stmt.setString(1, nim);
        rs = stmt.executeQuery();
        if (rs.next()) {
            response.sendRedirect("tambah.jsp?error=nim");
            return;
        }
        rs.close();
        stmt.close();

        if (mhs.tambah()) {
%>
    <script>
        Swal.fire({
            title: 'Sukses!',
            text: 'Data mahasiswa berhasil ditambahkan.',
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
            window.location.href = 'index.jsp';
        });
    </script>
<%
        } else {
            response.sendRedirect("tambah.jsp?error=gagal");
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
    <a href="index.jsp" class="btn-kembali">⬅ Kembali ke Halaman Utama</a>
</div>

<footer>© 2025 Portal Mahasiswa</footer>

</body>
</html>