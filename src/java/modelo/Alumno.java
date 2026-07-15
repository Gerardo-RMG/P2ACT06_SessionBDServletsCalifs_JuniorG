package modelo;

public class Alumno {

    private String matricula;
    private String nombre;
    private String paterno;
    private String materno;
    private String correo;
    private String clave;
    private boolean validar;
    private String status;
    private String fechaRegistro;

    public Alumno() {}

    public String getMatricula()         { return matricula; }
    public void   setMatricula(String m) { this.matricula = m; }

    public String getNombre()            { return nombre; }
    public void   setNombre(String n)    { this.nombre = n; }

    public String getPaterno()           { return paterno; }
    public void   setPaterno(String p)   { this.paterno = p; }

    public String getMaterno()           { return materno; }
    public void   setMaterno(String m)   { this.materno = m; }

    public String  getCorreo()           { return correo; }
    public void    setCorreo(String c)   { this.correo = c; }

    public String  getClave()            { return clave; }
    public void    setClave(String c)    { this.clave = c; }

    public boolean isValidar()           { return validar; }
    public void    setValidar(boolean v) { this.validar = v; }

    public String  getStatus()                { return status; }
    public void    setStatus(String s)        { this.status = s; }

    public String  getFechaRegistro()         { return fechaRegistro; }
    public void    setFechaRegistro(String f) { this.fechaRegistro = f; }

    public String getNombreCompleto() {
        return nombre + " " + paterno + (materno != null && !materno.isEmpty() ? " " + materno : "");
    }
}
