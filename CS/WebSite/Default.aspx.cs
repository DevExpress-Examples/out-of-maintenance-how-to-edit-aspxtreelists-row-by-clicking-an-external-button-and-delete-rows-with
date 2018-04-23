using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DevExpress.Web.ASPxTreeList;

public partial class _Default : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {
        tree.DataBind();
    }
    protected void tree_DataBinding(object sender, EventArgs e) {
        (sender as ASPxTreeList).DataSource = CustomDataSource;
    }

    protected void tree_NodeUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e) {
        DataRow dRow = CustomDataSource.Rows.Find(e.Keys["Id"]);
        dRow[0] = e.NewValues["Id"];
        dRow[1] = e.NewValues["Description"];
        UpdateSession();
        e.Cancel = true;
        tree.CancelEdit();
    }
    protected void tree_NodeInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e) {
        CustomDataSource.Rows.Add(e.NewValues["Id"], e.NewValues["Description"], e.NewValues["ParentId"]);
        UpdateSession();
        e.Cancel = true;
        tree.CancelEdit();
    }
    private void UpdateSession() {
        Session["CustomDataSource"] = CustomDataSource;
        tree.DataBind();
    }
    private DataTable CustomDataSource {
        get {
            DataTable result = Session["CustomDataSource"] as DataTable;
            if (result == null) {
                result = new DataTable("DataTable");
                result.Columns.Add("Id", typeof(int));
                result.PrimaryKey = new DataColumn[] { result.Columns[0] };
                result.Columns.Add("Description", typeof(string));
                result.Columns.Add("ParentId", typeof(int));

                result.Rows.Add(1, "Text1");
                result.Rows.Add(2, "Text2", 1);
                result.Rows.Add(3, "Text3", 1);
                result.Rows.Add(4, "Text4");
                result.Rows.Add(5, "Text5");
                Session["CustomDataSource"] = result;
            }
            return result;
        }
    }
    protected void tree_NodeDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e) {
        int id = Convert.ToInt32(e.Keys[0]);
        DataRow item = CustomDataSource.Rows.Find(id);
        CustomDataSource.Rows.Remove(item);
        UpdateSession();
        e.Cancel = true;
    }
}
