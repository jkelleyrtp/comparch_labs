use std::path::Path;

pub mod ffi {
    #[allow(non_camel_case_types)]
    pub enum top {}

    extern {
        pub fn top_new() -> *mut top;
        pub fn top_delete(top: *mut top);
        pub fn top_eval(top: *mut top);
        pub fn top_trace(top: *mut top, vcd: *mut ::verilated::vcd::VcdC, levels: ::std::os::raw::c_int);
        pub fn top_final(top: *mut top);
        pub fn top_clk_i_toggle(top: *mut top);
        pub fn top_rst_i_toggle(top: *mut top);
        pub fn top_get_count_o(top: *mut top) -> ::std::os::raw::c_uchar;
    }
}

pub struct Top(*mut ffi::top, Option<::verilated::vcd::Vcd>);

impl Default for Top {
    fn default() -> Self {
        let ptr = unsafe { ffi::top_new() };
        assert!(!ptr.is_null());
        Top(ptr, None)
    }
}

impl Drop for Top {
    fn drop(&mut self) {
        unsafe {
            ffi::top_delete(self.0);
        }
    }
}

#[allow(dead_code, non_snake_case)]
impl Top {
    pub fn count_o(&self) -> u8 {
        unsafe { ffi::top_get_count_o(self.0) }
    }


    pub fn eval(&mut self) {
        unsafe {
            ffi::top_eval(self.0);
        }
    }

    pub fn finish(&mut self) {
        unsafe {
            ffi::top_final(self.0);
        }
    }

    pub fn open_trace<P: AsRef<Path>>(&mut self, path: P, levels: i32) -> std::io::Result<()> {
        ::verilated::trace_ever_on(true);
        let mut vcd = ::verilated::vcd::Vcd::default();
        unsafe {
            ffi::top_trace(self.0, vcd.0, levels);
        }
        vcd.open(path)?;
        self.1 = Some(vcd);
        Ok(())
    }

    pub fn trace_at(&mut self, nanos: ::std::time::Duration) {
        if let Some(ref mut vcd) = self.1 {
            let timeui = nanos.as_secs() * 1_000_000_000 + u64::from(nanos.subsec_nanos());
            vcd.dump(timeui);
        }
    }

    pub fn clock_toggle(&mut self) {
        unsafe {
            ffi::top_clk_i_toggle(self.0);
        }
    }

    pub fn reset_toggle(&mut self) {
        unsafe {
            ffi::top_rst_i_toggle(self.0);
        }
    }

}
