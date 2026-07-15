package modelo;

public class Calificacion {

    private int    id;
    private String matricula;
    private String materiaClave;
    private String alumnoNombre;
    private String materiaNombre;
    private double p1;
    private double p2;
    private double p3;

    public Calificacion() {}

    public int    getId()                     { return id; }
    public void   setId(int id)               { this.id = id; }

    public String getMatricula()              { return matricula; }
    public void   setMatricula(String m)      { this.matricula = m; }

    public String getMateriaClave()           { return materiaClave; }
    public void   setMateriaClave(String c)   { this.materiaClave = c; }

    public String getAlumnoNombre()           { return alumnoNombre; }
    public void   setAlumnoNombre(String n)   { this.alumnoNombre = n; }

    public String getMateriaNombre()          { return materiaNombre; }
    public void   setMateriaNombre(String n)  { this.materiaNombre = n; }

    public double getP1()                     { return p1; }
    public void   setP1(double p1)            { this.p1 = p1; }

    public double getP2()                     { return p2; }
    public void   setP2(double p2)            { this.p2 = p2; }

    public double getP3()                     { return p3; }
    public void   setP3(double p3)            { this.p3 = p3; }

    public double calcProm() {
        return (p1 + p2 + p3) / 3.0;
    }
}
