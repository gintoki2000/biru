/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

namespace Biru.UI.Widgets {
    public class WarningLabel : Gtk.Box {
        private Gtk.Image icon;
        private Gtk.Label mess;
        private Gtk.Button button;

        public signal void sig_btn_reload ();

        public WarningLabel (string s) {
            Object ();
            this.mess = new Gtk.Label (s);
            this.button = new Gtk.Button.from_icon_name ("view-refresh-symbolic");

            this.pack_start (mess);
            this.pack_end (button);

            // connect signal
            this.button.clicked.connect ((event) => {
                sig_btn_reload ();
            });
        }

        public void set_label (string s) {
            this.mess.label = s;
        }
    }
}