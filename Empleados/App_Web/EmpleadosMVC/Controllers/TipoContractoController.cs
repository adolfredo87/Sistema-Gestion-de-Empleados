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
    public class TipoContractoController : Controller
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
            EmpleadosMVC.Models.TipoContracto tipoContratoDetail = db.TipoContractoSet.First(tc => tc.ID == id);
            return View(tipoContratoDetail);
        }

        public ActionResult Create()
        {
            EmpleadosMVC.Models.TipoContracto tipoContracto = new EmpleadosMVC.Models.TipoContracto();
            EmpleadosMVC.Models.TipoContracto tipoContractoToIDAdd = db.TipoContractoSet.ToList().LastOrDefault();
            Int32 _id = tipoContractoToIDAdd.ID + 1;
            tipoContracto.ID = _id;
            return View(tipoContracto);
        }

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            EmpleadosMVC.Models.TipoContracto tipoContractoToIDAdd = new EmpleadosMVC.Models.TipoContracto();

            string[] arreglo = new string[collection.AllKeys.ToList().Count];
            Int32 i = 0;

            foreach (var key in collection.AllKeys)
            {
                var value = collection[key];
                arreglo[i] = value;
                i++;
            }

            tipoContractoToIDAdd.Codigo = arreglo[0];
            tipoContractoToIDAdd.Descripcion = arreglo[1];
            String sMultiplo = arreglo[2];
            Int32 iMultiplo = Int32.Parse(sMultiplo);
            tipoContractoToIDAdd.MultiploAnual = iMultiplo;

            TryUpdateModel(tipoContractoToIDAdd, "TipoContracto");
            TryUpdateModel(tipoContractoToIDAdd, "TipoContracto", collection.ToValueProvider());

            // Si el modelo es valido, guardo en la BD
            if (ModelState.IsValid)
            {
                db.Connection.Open();
                DbTransaction dbTransaction = db.Connection.BeginTransaction();
                try
                {
                    // Guardar y confirmar.
                    db.AddToTipoContractoSet(tipoContractoToIDAdd);
                    db.SaveChanges();
                    dbTransaction.Commit();
                    /// Si la transaccion es exitosa nos redirigimos a la pagina de detalles como 
                    /// cofirmación de que la operacion resulto exitosa
                    EmpleadosMVC.Models.TipoContracto _entidadToIDAdd = db.TipoContractoSet.ToList().LastOrDefault();
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

            return View(tipoContractoToIDAdd);
        }

        public ActionResult Edit(Int32 id)
        {
            EmpleadosMVC.Models.TipoContracto tipoContractoToUpdate = db.TipoContractoSet.First(tc => tc.ID == id);
            ViewData.Model = tipoContractoToUpdate;
            return View();
        }

        [HttpPost]
        public ActionResult Edit(Int32 id, FormCollection form)
        {
            EmpleadosMVC.Models.TipoContracto tipoContractoToUpdate = db.TipoContractoSet.First(tc => tc.ID == id);

            string[] arreglo = new string[form.AllKeys.ToList().Count];
            Int32 i = 0;

            foreach (var key in form.AllKeys)
            {
                var value = form[key];
                arreglo[i] = value;
                i++;
            }

            tipoContractoToUpdate.Codigo = arreglo[0];
            tipoContractoToUpdate.Descripcion = arreglo[1];
            String sMultiplo = arreglo[2];
            Int32 iMultiplo = Int32.Parse(sMultiplo);
            tipoContractoToUpdate.MultiploAnual = iMultiplo;

            TryUpdateModel(tipoContractoToUpdate, "TipoContracto");
            TryUpdateModel(tipoContractoToUpdate, "TipoContracto", form.ToValueProvider());

            // Si el modelo es valido, guardo en la BD
            if (ModelState.IsValid)
            {
                db.Connection.Open();
                DbTransaction dbTransaction = db.Connection.BeginTransaction();
                try
                {
                    // Guardar y confirmar.
                    db.SaveChanges();
                    dbTransaction.Commit();
                    /// Si la transaccion es exitosa nos redirigimos a la pagina de detalles como 
                    /// cofirmación de que la operacion resulto exitosa
                    return RedirectToAction("Details/" + tipoContractoToUpdate.ID);
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

            return View(tipoContractoToUpdate);
        }

        public ActionResult Delete(int id)
        {
            EmpleadosMVC.Models.TipoContracto tipoContractoToDelete = db.TipoContractoSet.First(tc => tc.ID == id);
            ViewData.Model = tipoContractoToDelete;
            return View();
        }

        [HttpPost]
        public ActionResult Delete(Int32 id, FormCollection form)
        {
            EmpleadosMVC.Models.TipoContracto tipoContractoToDelete = db.TipoContractoSet.First(tc => tc.ID == id);

            //valido cliente tiene alquiler
            if (db.EmpleadoSet.FirstOrDefault(e => e.IDTipo == id) != null)
            {
                ModelState.AddModelError("ID", String.Format("Esta intentando Borrar un TipoContracto que tiene una Empleado"));
            }
            else
            {
                try
                {
                    // Delete 
                    db.DeleteObject(tipoContractoToDelete);
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
            }

            return View(tipoContractoToDelete);
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
            var tipoContractoDetail = db.TipoContractoSet.First(tc => tc.ID == id);

            return Json(tipoContractoDetail, JsonRequestBehavior.AllowGet);
        }

        [JsonHandleError()]
        public JsonResult GetJsonDetailsEdit(int id)
        {
            var tipoContractoDetail = db.TipoContractoSet.First(tc => tc.ID == id);

            return Json(tipoContractoDetail, JsonRequestBehavior.AllowGet);
        }

        [JsonHandleError()]
        public JsonResult GetListData(string sidx, string sord, int page, int rows,
               bool _search, string searchField, string searchOper, string searchString)
        {
            var tipoContracto = db.TipoContractoSet.ToList().AsQueryable();

            // Filter the list
            var filteredTipoContracto = tipoContracto;

            filteredTipoContracto = Utility.Filter<TipoContracto>(tipoContracto, _search, searchField, searchOper, searchString);

            // Sort the list
            var sortedTipoContracto = Utility.Sort<TipoContracto>(filteredTipoContracto, sidx, sord);

            sortedTipoContracto = sortedTipoContracto.Skip((page - 1) * rows).Take(rows);

            var totalRecords = filteredTipoContracto.Count();
            var totalPages = (int)Math.Ceiling((double)totalRecords / (double)rows);

            // Prepare the data to fit the requirement of jQGrid
            var data = (from s in sortedTipoContracto
                        select new
                        {
                            id = s.ID,
                            cell = new object[] { 
                                s.ID, 
                                s.Codigo, 
                                s.Descripcion, 
                                s.MultiploAnual, 
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
