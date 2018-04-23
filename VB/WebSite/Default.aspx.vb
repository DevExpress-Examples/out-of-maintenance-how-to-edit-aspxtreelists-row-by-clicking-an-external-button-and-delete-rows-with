Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Configuration
Imports System.Collections
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls
Imports DevExpress.Web.ASPxTreeList

Partial Public Class _Default
	Inherits System.Web.UI.Page
	Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		tree.DataBind()
	End Sub
	Protected Sub tree_DataBinding(ByVal sender As Object, ByVal e As EventArgs)
        TryCast(sender, ASPxTreeList).DataSource = CustomDataSource
	End Sub

	Protected Sub tree_NodeUpdating(ByVal sender As Object, ByVal e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
		Dim dRow As DataRow = CustomDataSource.Rows.Find(e.Keys("Id"))
		dRow(0) = e.NewValues("Id")
		dRow(1) = e.NewValues("Description")
		UpdateSession()
		e.Cancel = True
		tree.CancelEdit()
	End Sub
	Protected Sub tree_NodeInserting(ByVal sender As Object, ByVal e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
		CustomDataSource.Rows.Add(e.NewValues("Id"), e.NewValues("Description"), e.NewValues("ParentId"))
		UpdateSession()
		e.Cancel = True
		tree.CancelEdit()
	End Sub
	Private Sub UpdateSession()
		Session("CustomDataSource") = CustomDataSource
		tree.DataBind()
	End Sub
	Private ReadOnly Property CustomDataSource() As DataTable
		Get
			Dim result As DataTable = TryCast(Session("CustomDataSource"), DataTable)
			If result Is Nothing Then
				result = New DataTable("DataTable")
				result.Columns.Add("Id", GetType(Integer))
				result.PrimaryKey = New DataColumn() { result.Columns(0) }
				result.Columns.Add("Description", GetType(String))
				result.Columns.Add("ParentId", GetType(Integer))

				result.Rows.Add(1, "Text1")
				result.Rows.Add(2, "Text2", 1)
				result.Rows.Add(3, "Text3", 1)
				result.Rows.Add(4, "Text4")
				result.Rows.Add(5, "Text5")
				Session("CustomDataSource") = result
			End If
			Return result
		End Get
	End Property
	Protected Sub tree_NodeDeleting(ByVal sender As Object, ByVal e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
		Dim id As Integer = Convert.ToInt32(e.Keys(0))
		Dim item As DataRow = CustomDataSource.Rows.Find(id)
		CustomDataSource.Rows.Remove(item)
		UpdateSession()
		e.Cancel = True
	End Sub
End Class
