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

using Biru.UI.Widgets;
using Biru.Service.Models;

namespace Biru.UI.Windows {
    enum ReaderPage {
        PAGE_PREV,
        PAGE_CURR,
        PAGE_NEXT
    }

    public class ReaderImage : Gtk.Overlay {
        private Image image;

        public ReaderImage () {
            this.image = new Image ();
            this.add (image);
        }

        public void load (string url) {
            this.image.clear ();
            this.image.set_from_url_async.begin (url, 800, 1000, true, null, () => {
                stdout.printf ("done\n");
            });
        }
    }

    public class Reader : Gtk.Window {
        private int view { get; set; default = 0; }
        private uint page { get; set; default = 0; }
        private unowned Book book;
        private Gtk.Stack stack;
        private ReaderImage image[3];
        private Gtk.StackTransitionType anim;
        private List<string ? > page_urls;

        public Reader (Book book) {
            Object ();
            this.get_style_context ().add_class ("reader");
            // this.fullscreen();
            this.book = book;
            this.page_urls = book.page_urls ();
            this.anim = Gtk.StackTransitionType.CROSSFADE;
            for (var i = 0; i < 3; i++) {
                image[i] = new ReaderImage ();
            }

            this.stack = new Gtk.Stack ();
            this.stack.set_transition_duration (100);
            for (var i = 0; i < 3; i++) {
                this.stack.add_named (image[i], i.to_string ());
            }

            this.add (stack);
            bind_keys ();
        }

        void bind_keys () {
            this.key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                switch (keycode) {
                    case 9:
                        this.close ();
                        break;
                    case 114:
                        this.next ();
                        break;
                    case 113:
                        this.prev ();
                        break;
                }
                return true;
            });
        }

        public void switch_view (int v) {
            this.stack.set_visible_child_full (v.to_string (), anim);
            this.view = v;
        }

        public void next () {
            if (this.view == 2) {
                this.switch_view (0);
                message ("preloading view 1 & 2");
                load (1, page + 1);
                // load(2, page+2);
            } else if (this.view == 1) {
                this.switch_view (2);
                message ("preloading view 0 & 1");
                load (0, page + 1);
                // load (1, page+2);
            } else if (this.view == 0) {
                this.switch_view (1);
                message ("preloading view 2 & 0");
                load (2, page + 1);
                // load (0, page+2);
            }
            message ("next");
            page += 1;
        }

        public void prev () {
            message ("prev");
        }

        public void load (int view, uint page) {
            this.image[view].load (this.page_urls.nth_data (page));
        }

        public void init () {
            load (0, page);
            load (1, page + 1);
            load (2, page + 2);
            this.stack.set_visible_child_full ("0", anim);
        }
    }
}
