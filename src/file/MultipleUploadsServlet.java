package file;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(urlPatterns = { "/multipleUploads" })
@MultipartConfig
public class MultipleUploadsServlet extends HttpServlet {

    private static final long serialVersionUID = 9991L;

    private String getFilename(Part part) {
        String contentDispositionHeader = 
                part.getHeader("content-disposition");
        String[] elements = contentDispositionHeader.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1)
                        .trim().replace("\"", "");
            }
        }
        return null;
    }

    public void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException,
            IOException {
        
    	response.setCharacterEncoding("utf-8");
        response.setContentType("text/html");
        PrintWriter writer = response.getWriter();

        Collection<Part> parts = request.getParts();
        for (Part part : parts) {
            if (part.getContentType() != null) {
            	// 파일 Part 를 디스크에 저장
                String fileName = getFilename(part);
                if (fileName != null && !fileName.isEmpty()) {
                    part.write(getServletContext().getRealPath(
                            "/WEB-INF") + "/" + fileName);
                    writer.print("<br/>업로드한 파일 이름: " +
                            fileName);
                    writer.print("<br/>크기: " + part.getSize());
                }
            } else {
            	// 필드 이름/값을 출력
                String partName = part.getName();
                String fieldValue = new String(request.getParameter(partName).getBytes("iso-8859-1"), "utf-8");
                writer.print("<br/>" + partName + ": " + 
                        fieldValue);
            }
        }        
    }
}