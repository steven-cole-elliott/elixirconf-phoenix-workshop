defmodule AcmeWeb.IssueChannel do
  use AcmeWeb, :channel
  alias AcmeWeb.Presence

  def join("issues:" <> id, _payload, socket) do
    # we are already authorizing at the user_socket level...
    # if authorized?(payload) do
    #   {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
    issue = Acme.Support.get_issue!(id)

    # this is some advanced stuff;
    send(self(), :after_join)
    # this keeps the issue in our state in the socket
    {:ok, assign(socket, :issue, issue)}
  end

  def handle_in("new_comment", payload, socket) do
    user = socket.assigns.user
    issue = socket.assigns.issue

    {:ok, comment} = Acme.Support.create_comment(issue, user, payload)
    formatted_comment = format_comment(comment)

    broadcast socket, "new_comment", formatted_comment

    {:reply, {:ok, formatted_comment}, socket}
  end

  # this is invoked by the send(self(), :after_join) above...
  def handle_info(:after_join, socket) do
    user = socket.assigns.user
    issue = Acme.Support.fetch_issue_comments(socket.assigns.issue)
    comments = Enum.map(issue.comments, &format_comment/1)

    push socket, "current_user_data", user_data(user)
    push socket, "comment_history", %{comments: comments}
    # gets a list of all of the things that are registered with this topic?
    push socket, "presence_state", Presence.list(socket)

    # tracks our state in the presence with our user as metadata?
    Presence.track(socket, user.id, user_data(user))

    {:noreply, socket}
  end

  defp format_comment(comment) do
    %{id: comment.id,
      from: comment.user.name,
      avatarUrl: avatar_url(comment.user),
      body: comment.body
    }
  end

  defp avatar_url(user) do
    Exgravatar.gravatar_url(user.email, s: 128)
  end

  defp user_data(user) do
    %{name: user.name, avatarUrl: avatar_url(user)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (issue:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
