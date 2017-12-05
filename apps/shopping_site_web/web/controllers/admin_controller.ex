defmodule ShoppingSiteWeb.AdminController do
    use ShoppingSiteWeb.Web, :controller
    alias Decimal, as: D

    alias ShoppingSite.{ItemQueries, Items}

    def admin(conn, _params) do
        id = Plug.Conn.get_session(conn, :current_user)
        if id do
            items = ItemQueries.get_all_items
            changeset = Items.changeset(%Items{})
            render conn, "admin.html", items: items, changeset: changeset
        else
            conn |> redirect(to: "/login")
        end
    end


    def create(conn, %{"item" => %{ "description" => des, "name" => name,
                                    "image" => upload, "price" => price }}) do

        # file uploading

        ShoppingSiteWeb.ItemPicture.store(upload)

        ItemQueries.insert_item name, des, D.new(price), upload.filename

        redirect(conn, to: "/admin")
    end

    
    def create(conn, %{"item" => %{ "description" => des, "name" => name, 
                                    "price" => price}}) do

        ItemQueries.insert_item name, des, D.new(price),
                                Application.get_env(:shopping_site_web, :placeholder_url)

        redirect(conn, to: "/admin")
    end


    def search(conn, %{"search" => %{"query" => query}}) do
        items = ShoppingSite.ItemQueries.search_items query
        render conn, "admin.html", items: items
    end


    def edit(conn, _params) do
        #TODO: implement
        render conn, "admin.html" 
    end
end