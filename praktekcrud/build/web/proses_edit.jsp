<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hasil Update</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f8fb;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #0d47a1;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .info-header {
            font-size: 16px;
        }

        footer {
            background-color: #0d47a1;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 14px;
            margin-top: 60px;
        }
    </style>
</head>
<body>
<header>
    <div class="logo">🎓 Portal Mahasiswa</div>
    <div class="info-header">🚀 Praktek Java Lanjutan </div>
</header>
<%
    String id = request.getParameter("id");
    String nim = request.getParameter("nim");
    String nama = request.getParameter("nama");
    String nilaiStr = request.getParameter("nilai");

    if (nim == null || nim.trim().isEmpty() ||
        nama == null || nama.trim().isEmpty() ||
        nilaiStr == null || nilaiStr.trim().isEmpty()) {
%>
    <div class="notif error">
        <div class="icon">❌</div>
        <h2>Gagal update: Semua field harus diisi!</h2>
        <a href="edit.jsp?id=<%= id %>" class="btn">⬅ Kembali ke Form</a>
    </div>
<%
    } else if (!nim.matches("\\d{8}")) {
%>
    <div class="notif error">
        <div class="icon">❌</div>
        <h2>NIM harus terdiri dari 8 digit angka!</h2>
        <a href="edit.jsp?id=<%= id %>" class="btn">⬅ Kembali ke Form</a>
    </div>
<%
    } else {
        try {
            int nilai = Integer.parseInt(nilaiStr);
            if (nilai < 0) {
%>
    <div class="notif error">
        <div class="icon">❌</div>
        <h2>Nilai harus angka positif!</h2>
        <a href="edit.jsp?id=<%= id %>" class="btn">⬅ Kembali ke Form</a>
    </div>
<%
            } else {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crud", "root", "");

                PreparedStatement cekNim = conn.prepareStatement("SELECT COUNT(*) FROM mahasiswa WHERE nim = ? AND id != ?");
                cekNim.setString(1, nim);
                cekNim.setInt(2, Integer.parseInt(id));
                ResultSet rsNim = cekNim.executeQuery();
                rsNim.next();
                if (rsNim.getInt(1) > 0) {
%>
    <script>
        Swal.fire({
            title: 'Gagal!',
            text: 'NIM sudah digunakan oleh mahasiswa lain!',
            icon: 'error',
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
            window.location.href = 'edit.jsp?id=<%= id %>';
        });
    </script>
<%
                    conn.close();
                    return;
                }
                PreparedStatement cekNama = conn.prepareStatement("SELECT COUNT(*) FROM mahasiswa WHERE nama = ? AND id != ?");
                cekNama.setString(1, nama);
                cekNama.setInt(2, Integer.parseInt(id));
                ResultSet rsNama = cekNama.executeQuery();
                rsNama.next();
                if (rsNama.getInt(1) > 0) {
%>
    <script>
        Swal.fire({
            title: 'Gagal!',
            text: 'Nama sudah digunakan oleh mahasiswa lain!',
            icon: 'error',
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
            window.location.href = 'edit.jsp?id=<%= id %>';
        });
    </script>
<%
                    conn.close();
                    return;
                }
                String sql = "UPDATE mahasiswa SET nim=?, nama=?, nilai=? WHERE id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nim);
                stmt.setString(2, nama);
                stmt.setInt(3, nilai);
                stmt.setInt(4, Integer.parseInt(id));
                stmt.executeUpdate();
                conn.close();
%>
    <script>
        Swal.fire({
            title: 'Sukses!',
            text: 'Data mahasiswa berhasil diupdate.',
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
            }
        } catch (NumberFormatException e) {
%>
    <div class="notif error">
        <div class="icon">❌</div>
        <h2>Nilai harus berupa angka yang valid!</h2>
        <a href="edit.jsp?id=<%= id %>" class="btn">⬅ Kembali ke Form</a>
    </div>
<%
        } catch (Exception e) {
%>
    <div class="notif error">
        <div class="icon">❌</div>
        <h2>Gagal update data: <%= e.getMessage() %></h2>
        <a href="edit.jsp?id=<%= id %>" class="btn">⬅ Kembali ke Form</a>
    </div>
<%
        }
    }
%>
<footer>© 2025 Portal Mahasiswa</footer>

</body>
</html>