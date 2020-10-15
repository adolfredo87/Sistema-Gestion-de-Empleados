using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using EmpleadosMVC.Models;
using EmpleadosMVC.Utilitys;
using System.Threading;
using System.Data.OleDb;
using System.Data.Common;

namespace EmpleadosMVC.Controllers
{
    [HandleError()]
    public class EmpleadoController : Controller
    {
        private EmpleadosMVC.Models.DemoEmpleadosEntities db = new EmpleadosMVC.Models.DemoEmpleadosEntities();

        public ActionResult Index()
        {
            return RedirectToAction("List");
        }

        public ActionResult List()
        {
            return View();
        }

        public ActionResult Details(int id)
        {
            EmpleadosMVC.Models.Empleado empleadoDetail = db.EmpleadoSet.First(tc => tc.ID == id);
            return View(empleadoDetail);
        }

        public ActionResult Create()
        {
            EmpleadosMVC.Models.Empleado empleado = new Empleado();
            EmpleadosMVC.Models.Empleado empleadoToIDAdd = db.EmpleadoSet.ToList().LastOrDefault();
            empleado.TipoContracto = db.TipoContractoSet.FirstOrDefault();
            Int32 _id = empleadoToIDAdd.ID + 1;
            empleado.ID = _id;
            return View(empleado);
        }

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            EmpleadosMVC.Models.Empleado empleadoToAdd = new EmpleadosMVC.Models.Empleado();

            string[] arreglo = new string[collection.AllKeys.ToList().Count];
            Int32 i = 0;

            foreach (var key in collection.AllKeys)
            {
                var value = collection[key];
                arreglo[i] = value;
                i++;
            }

            empleadoToAdd.DNI = arreglo[0];
            empleadoToAdd.Nombre = arreglo[1];
            empleadoToAdd.Telefono = arreglo[2];
            empleadoToAdd.Correo = arreglo[3];
            empleadoToAdd.Direccion = arreglo[4];
            
            String sSueldo = arreglo[5];
            Double dSueldo = Double.Parse(sSueldo);
            empleadoToAdd.Sueldo = dSueldo;
            
            String sSueldoAnual = arreglo[6];
            Double dSueldoAnual = Double.Parse(sSueldoAnual);
            empleadoToAdd.SueldoAnual = dSueldoAnual;
            
            String sEstatus = arreglo[7];
            Int32 iEstatus = Int32.Parse(sEstatus);
            empleadoToAdd.Estatus = iEstatus;

            String sIDTipo = arreglo[8];
            Int32 iIDTipo = Int32.Parse(sIDTipo);
            empleadoToAdd.IDTipo = iIDTipo;

            if (!String.IsNullOrEmpty(sIDTipo))
            {
                empleadoToAdd.TipoContracto = db.TipoContractoSet.FirstOrDefault(tc => tc.ID == iIDTipo);
            }

            if (empleadoToAdd.TipoContracto == null)
            {
                ModelState.AddModelError("ID", String.Format("El número de Tipo Contrato {0} no está registrado en la base de datos.", sIDTipo));
            }

            TryUpdateModel(empleadoToAdd, "Empleado");
            TryUpdateModel(empleadoToAdd, "Empleado", collection.ToValueProvider());

            //valido claves primaria
            if (db.EmpleadoSet.FirstOrDefault(c => c.ID == empleadoToAdd.ID) != null)
            {
                ModelState.AddModelError("ID", String.Format("Violacion Clave primaria", "ID"));
            }
            else
            {
                // Si el modelo es valido, guardo en la BD
                if (ModelState.IsValid)
                {
                    db.Connection.Open();
                    DbTransaction dbTransaction = db.Connection.BeginTransaction();

                    try
                    {
                        // Guardar y confirmar el Empleado.
                        db.AddToEmpleadoSet(empleadoToAdd);
                        db.SaveChanges();
                        dbTransaction.Commit();
                        /// Si la transaccion es exitosa nos redirigimos a la pagina de detalles como 
                        /// cofirmación de que la operacion resulto exitosa
                        EmpleadosMVC.Models.Empleado _entidadToIDAdd = db.EmpleadoSet.ToList().LastOrDefault();
                        Int32 _id = _entidadToIDAdd.ID;
                        _entidadToIDAdd.ID = _id;
                        return RedirectToAction("Details/" + _entidadToIDAdd.ID);
                    }
                    catch (Exception ex)
                    {
                        dbTransaction.Rollback();
                        HandleException excepcion = new HandleException();
                        String msjLog = "Error en " + ObtenerMetodoEnEjecucion(false).ToString() + ".\n" + excepcion.RegistrarExcepcion(ex, ObtenerMetodoEnEjecucion(false).ToString());
                        excepcion.EscribirLogExcepcion(msjLog); String clientMessage = excepcion.HandleExceptionEx(ex); excepcion = null;
                        ModelState.AddModelError("ID", clientMessage);
                    }
                }
            }

            return View(empleadoToAdd);
        }

        public ActionResult Edit(Int32 id)
        {
            EmpleadosMVC.Models.Empleado empleadoToUpdate = db.EmpleadoSet.First(tc => tc.ID == id);
            ViewData.Model = empleadoToUpdate;
            return View();
        }

        [HttpPost]
        public ActionResult Edit(Int32 id, FormCollection form)
        {
            EmpleadosMVC.Models.Empleado empleadoToUpdate = db.EmpleadoSet.First(tc => tc.ID == id);

            string[] arreglo = new string[form.AllKeys.ToList().Count];
            Int32 i = 0;

            foreach (var key in form.AllKeys)
            {
                var value = form[key];
                arreglo[i] = value;
                i++;
            }

            empleadoToUpdate.Nombre = arreglo[0];
            empleadoToUpdate.Telefono = arreglo[1];
            empleadoToUpdate.Correo = arreglo[2];
            empleadoToUpdate.Direccion = arreglo[3];

            String sSueldo = arreglo[4];
            Double dSueldo = Double.Parse(sSueldo);
            empleadoToUpdate.Sueldo = dSueldo;

            String sSueldoAnual = arreglo[5];
            Double dSueldoAnual = Double.Parse(sSueldoAnual);
            empleadoToUpdate.SueldoAnual = dSueldoAnual;

            String sEstatus = arreglo[6];
            Int32 iEstatus = Int32.Parse(sEstatus);
            empleadoToUpdate.Estatus = iEstatus;

            String sIDTipo = arreglo[7];
            Int32 iIDTipo = Int32.Parse(sIDTipo);
            empleadoToUpdate.IDTipo = iIDTipo;

            if (!String.IsNullOrEmpty(sIDTipo))
            {
                empleadoToUpdate.TipoContracto = db.TipoContractoSet.FirstOrDefault(tc => tc.ID == iIDTipo);
            }

            if (empleadoToUpdate.TipoContracto == null)
            {
                ModelState.AddModelError("ID", String.Format("El número de Tipo Contrato {0} no está registrado en la base de datos.", sIDTipo));
            }

            TryUpdateModel(empleadoToUpdate, "Empleado");
            TryUpdateModel(empleadoToUpdate, "Empleado", form.ToValueProvider());

            // Si el modelo es valido, guardo en la BD
            if (ModelState.IsValid)
            {
                db.Connection.Open();
                DbTransaction dbTransaction = db.Connection.BeginTransaction();
                try
                {
                    // Guardar y confirmar el Empleado.
                    db.SaveChanges();
                    dbTransaction.Commit();
                    /// Si la transaccion es exitosa nos redirigimos a la pagina de detalles como 
                    /// cofirmación de que la operacion resulto exitosa
                    return RedirectToAction("Details/" + empleadoToUpdate.ID);
                }
                catch (Exception ex)
                {
                    dbTransaction.Rollback();
                    HandleException excepcion = new HandleException();
                    String msjLog = "Error en " + ObtenerMetodoEnEjecucion(false).ToString() + ".\n" + excepcion.RegistrarExcepcion(ex, ObtenerMetodoEnEjecucion(false).ToString());
                    excepcion.EscribirLogExcepcion(msjLog); String clientMessage = excepcion.HandleExceptionEx(ex); excepcion = null;
                    ModelState.AddModelError("ID", clientMessage);
                }
            }

            return View(empleadoToUpdate);
        }

        public ActionResult Delete(int id)
        {
            EmpleadosMVC.Models.Empleado empleadoToDelete = db.EmpleadoSet.First(tc => tc.ID == id);
            ViewData.Model = empleadoToDelete;
            return View();
        }

        [HttpPost]
        public ActionResult Delete(Int32 id, FormCollection form)
        {
            EmpleadosMVC.Models.Empleado empleadoToDelete = db.EmpleadoSet.First(tc => tc.ID == id);

            try
            {
                // Delete 
                db.DeleteObject(empleadoToDelete);
                db.SaveChanges();
                // Retorno a la vista del listar
                return RedirectToAction("List");
            }
            catch (Exception ex)
            {
                HandleException excepcion = new HandleException();
                String msjLog = "Error en " + ObtenerMetodoEnEjecucion(false).ToString() + ".\n" + excepcion.RegistrarExcepcion(ex, ObtenerMetodoEnEjecucion(false).ToString());
                excepcion.EscribirLogExcepcion(msjLog); String clientMessage = excepcion.HandleExceptionEx(ex); excepcion = null;
                ModelState.AddModelError("ID", clientMessage);
            }

            return View(empleadoToDelete);
        }

        private System.String ObtenerMetodoEnEjecucion(bool nombreCorto)
        {
            if (nombreCorto)
            {
                return new System.Diagnostics.StackTrace().GetFrame(1).GetMethod().Name;
            }
            else
            {
                return this.ToString() + "." + new System.Diagnostics.StackTrace().GetFrame(1).GetMethod().Name;
            }
        }

        #region << METODOS JSON - AJAX , JQUERY>>

        [JsonHandleError()]
        public JsonResult GetJsonDetails(int id)
        {
            var EmpleadoDetail = db.EmpleadoSet.First(tc => tc.ID == id);

            return Json(EmpleadoDetail, JsonRequestBehavior.AllowGet);
        }

        [JsonHandleError()]
        public JsonResult GetJsonDetailsEdit(int id)
        {
            var EmpleadoDetail = db.EmpleadoSet.First(tc => tc.ID == id);

            return Json(EmpleadoDetail, JsonRequestBehavior.AllowGet);
        }

        [JsonHandleError()]
        public JsonResult GetListData(string sidx, string sord, int page, int rows,
               bool _search, string searchField, string searchOper, string searchString)
        {
            var Empleado = db.EmpleadoSet.ToList().AsQueryable();

            // Filter the list
            var filteredEmpleado = Empleado;

            filteredEmpleado = Utility.Filter<Empleado>(Empleado, _search, searchField, searchOper, searchString);

            // Sort the list
            var sortedEmpleado = Utility.Sort<Empleado>(filteredEmpleado, sidx, sord);

            sortedEmpleado = sortedEmpleado.Skip((page - 1) * rows).Take(rows);

            var totalRecords = filteredEmpleado.Count();
            var totalPages = (int)Math.Ceiling((double)totalRecords / (double)rows);

            // Prepare the data to fit the requirement of jQGrid
            var data = (from s in sortedEmpleado
                        select new
                        {
                            id = s.ID,
                            cell = new object[] { 
                                s.ID, 
                                s.DNI, 
                                s.Nombre, 
                                s.Telefono, 
                                s.Correo, 
                                s.Sueldo, 
                                s.SueldoAnual, 
                                s.TipoContracto == null ? "" : s.TipoContracto.Descripcion, 
                                s.Estatus, 
                            }
                        });
            // Send the data to the jQGrid
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = data
            };

            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}
