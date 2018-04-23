<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v10.2, Version=10.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v10.2, Version=10.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v10.2, Version=10.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxPopupControl" TagPrefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>How to insert (or update) ASPxTreeList's row by clicking on an external button and delete rows with custom confirmation popup window</title>

    <script language="javascript" type="text/javascript">
            function ConfirmDelete(s, e) {
                if (e.buttonID != 'btnDelete')
                    return;

                e.processOnServer = false;
                treeList.GetNodeValues(e.nodeKey, "Id;Description", OnGetInfo);
            }

            function OnGetInfo(value) {
                lItemInfo.SetText("Id:" + value[0] + " Description: " + value[1]);                
                popConfirm.deletedRowKey = value[0];
                popConfirm.Show();
            }

            function DeleteConfirmed() {
                popConfirm.Hide();
                treeList.DeleteNode(popConfirm.deletedRowKey); 
                popConfirm.deletedRowKey = null;
            }
            function StartTreeListEdit() {
                var focusedNodeKey = treeList.GetFocusedNodeKey();
                if (!focusedNodeKey)
                    return;
                treeList.StartEdit(focusedNodeKey);                
            }
            function StartTreeListNewEdit() {
                var focusedNodeKey = treeList.GetFocusedNodeKey();
                if (!focusedNodeKey)
                    treeList.StartEditNewNode();
                else
                    treeList.StartEditNewNode(focusedNodeKey);                
            }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxTreeList ID="tree" runat="server" AutoGenerateColumns="False" OnDataBinding="tree_DataBinding"
                KeyFieldName="Id" OnNodeInserting="tree_NodeInserting" OnNodeUpdating="tree_NodeUpdating"
                ParentFieldName="ParentId" ClientInstanceName="treeList" EnableViewState="False"
                OnNodeDeleting="tree_NodeDeleting">
                <Columns>
                    <dx:TreeListTextColumn FieldName="Id" VisibleIndex="0">
                    </dx:TreeListTextColumn>
                    <dx:TreeListTextColumn FieldName="Description" VisibleIndex="1">
                    </dx:TreeListTextColumn>
                    <dx:TreeListCommandColumn VisibleIndex="2">
                        <UpdateButton Visible="True">
                        </UpdateButton>
                        <CancelButton Visible="True">
                        </CancelButton>
                        <CustomButtons>
                            <dx:TreeListCommandColumnCustomButton ID="btnDelete" Text="Delete">
                            </dx:TreeListCommandColumnCustomButton>
                        </CustomButtons>
                    </dx:TreeListCommandColumn>
                    <dx:TreeListTextColumn FieldName="ParentId" Visible="False" VisibleIndex="3">
                    </dx:TreeListTextColumn>
                </Columns>
                <SettingsBehavior AllowFocusedNode="True" />
                <SettingsEditing ConfirmDelete="False" />
                <ClientSideEvents CallbackError="function(s, e) { e.handled = true; lError.SetText(e.message); popError.Show(); }"
                    CustomButtonClick="ConfirmDelete" />
            </dx:ASPxTreeList>
        </div>
        <table>
            <tr>
                <td>
                    <dx:ASPxButton ID="btnEdit" runat="server" Text="Edit" AutoPostBack="False">
                        <ClientSideEvents Click="function(s, e) { StartTreeListEdit(); }" />
                    </dx:ASPxButton>
                </td>
                <td>
                    <dx:ASPxButton ID="btnNew" runat="server" Text="New" AutoPostBack="False">
                        <ClientSideEvents Click="function(s, e) { StartTreeListNewEdit(); }" />
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>
        <dx:ASPxPopupControl ID="popError" runat="server" CloseAction="CloseButton" HeaderText="Error"
            ClientInstanceName="popError" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="lError" runat="server" ClientInstanceName="lError" Text="ASPxLabel">
                    </dx:ASPxLabel>
                    <dx:ASPxButton ID="btnOK" runat="server" Text="OK" AutoPostBack="False">
                        <ClientSideEvents Click="function(s, e) { popError.Hide();  e.processOnServer = false; }" />
                    </dx:ASPxButton>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="popConfirm" runat="server" ClientInstanceName="popConfirm"
            Text=" you want to delete an item:" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server" SupportsDisabledAttribute="True">
                    <br />
                    <dx:ASPxLabel ID="lItemInfo" runat="server" Text="ASPxLabel" ClientInstanceName="lItemInfo">
                    </dx:ASPxLabel>
                    <table>
                        <tr>
                            <td>
                                <dx:ASPxButton ID="btnYes" runat="server" Text="YES" AutoPostBack="False">
                                    <ClientSideEvents Click="DeleteConfirmed" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="btnNo" runat="server" Text="NO" AutoPostBack="False">
                                    <ClientSideEvents Click="function(s, e) {  popConfirm.Hide();  e.processOnServer = false; }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>
</body>
</html>
