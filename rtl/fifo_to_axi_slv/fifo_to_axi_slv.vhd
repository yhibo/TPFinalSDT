----------------------------------------------------------------------------------
-- Institution: Instituto Balseiro
-- Deve:        José Quinteros
--
-- Design Name: TP1
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: AXI4-Lite Regs
--
-- Dependencies: None.
--
-- Revision: 2022-06-21
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_to_axi_slv is
  generic (
    -- Users to add parameters here
    -- User parameters ends
    -- Do not modify the parameters beyond this line

    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH : integer := 32;
    -- Width of S_AXI address bus
    C_S_AXI_ADDR_WIDTH : integer := 5
  );
  port (
    -- Users to add ports here
    fifo_full_in  : in std_logic;
    s_axis_tvalid : in std_logic;
    s_axis_tready : out std_logic;
    s_axis_tdata  : in std_logic_vector(63 downto 0);
    s_axis_tlast  : in std_logic;
    -- User ports ends
    -- Do not modify the ports beyond this line

    -- Global Clock Signal
    S_AXI_ACLK    : in std_logic;
    -- Global Reset Signal. This Signal is Active LOW
    S_AXI_ARESETN : in std_logic;
    -- Write address (issued by master, acceped by Slave)
    S_AXI_AWADDR  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
    -- Write channel Protection type. This signal indicates the
    -- privilege and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_AWPROT  : in std_logic_vector(2 downto 0);
    -- Write address valid. This signal indicates that the master signaling
    -- valid write address and control information.
    S_AXI_AWVALID : in std_logic;
    -- Write address ready. This signal indicates that the slave is ready
    -- to accept an address and associated control signals.
    S_AXI_AWREADY : out std_logic;
    -- Write data (issued by master, acceped by Slave)
    S_AXI_WDATA   : in std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
    -- Write strobes. This signal indicates which byte lanes hold
    -- valid data. There is one write strobe bit for each eight
    -- bits of the write data bus.
    S_AXI_WSTRB   : in std_logic_vector((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
    -- Write valid. This signal indicates that valid write
    -- data and strobes are available.
    S_AXI_WVALID  : in std_logic;
    -- Write ready. This signal indicates that the slave
    -- can accept the write data.
    S_AXI_WREADY  : out std_logic;
    -- Write response. This signal indicates the status
    -- of the write transaction.
    S_AXI_BRESP   : out std_logic_vector(1 downto 0);
    -- Write response valid. This signal indicates that the channel
    -- is signaling a valid write response.
    S_AXI_BVALID  : out std_logic;
    -- Response ready. This signal indicates that the master
    -- can accept a write response.
    S_AXI_BREADY  : in std_logic;
    -- Read address (issued by master, acceped by Slave)
    S_AXI_ARADDR  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether the
    -- transaction is a data access or an instruction access.
    S_AXI_ARPROT  : in std_logic_vector(2 downto 0);
    -- Read address valid. This signal indicates that the channel
    -- is signaling valid read address and control information.
    S_AXI_ARVALID : in std_logic;
    -- Read address ready. This signal indicates that the slave is
    -- ready to accept an address and associated control signals.
    S_AXI_ARREADY : out std_logic;
    -- Read data (issued by slave)
    S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
    -- Read response. This signal indicates the status of the
    -- read transfer.
    S_AXI_RRESP   : out std_logic_vector(1 downto 0);
    -- Read valid. This signal indicates that the channel is
    -- signaling the required read data.
    S_AXI_RVALID  : out std_logic;
    -- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
    S_AXI_RREADY  : in std_logic
  );
end fifo_to_axi_slv;

architecture arch_imp of fifo_to_axi_slv is

  -- AXI4LITE signals
  signal axi_awaddr : std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
  signal axi_awready : std_logic;
  signal axi_wready : std_logic;
  signal axi_bresp : std_logic_vector(1 downto 0);
  signal axi_bvalid : std_logic;
  signal axi_araddr : std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
  signal axi_arready : std_logic;
  signal axi_rdata : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
  signal axi_rresp : std_logic_vector(1 downto 0);
  signal axi_rvalid : std_logic;

  -- Example-specific design signals
  -- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
  -- ADDR_LSB is used for addressing 32/64 bit registers/memories
  -- ADDR_LSB = 2 for 32 bits (n downto 2)
  -- ADDR_LSB = 3 for 64 bits (n downto 3)
  constant ADDR_LSB : integer := (C_S_AXI_DATA_WIDTH/32) + 1;
  constant OPT_MEM_ADDR_BITS : integer := 2;
  ------------------------------------------------
  ---- Signals for user logic register space example
  --------------------------------------------------
  -- Note that these are the actual address offsets we will use in the bus.
  -- Internal decoding used a /4 version
  constant CORE_ID_ADDR : integer := 16#00#/4; -- RO
  constant FIFO_FULL_ADDR : integer := 16#04#/4; -- RO
  constant FIFO_FLUSH_EN_ADDR : integer := 16#08#/4; --RW
  constant FIFO_FLUSH_COUNT_MAX_ADDR : integer := 16#0C#/4; --RW
  constant FIFO_FLUSH_DONE_ADDR : integer := 16#10#/4; -- RO
  constant FIFO_DATA_RE_ADDR : integer := 16#14#/4; -- RO
  constant FIFO_DATA_IM_ADDR : integer := 16#18#/4; -- RO

  signal fifo_flush_en_reg : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0); -- selop1_i
  signal fifo_flush_count_max_reg : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0); -- selop1_i
  signal slv_reg_rden : std_logic;
  signal slv_reg_wren : std_logic;
  signal reg_data_out : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
  signal byte_index : integer;
  signal aw_en : std_logic;

  constant CORE_ID : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) := x"0000_cafe";
  constant READ_ERROR : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0) := x"DEADBEEF";

  signal axis_tready_from_axi_reg : std_logic;
  signal axis_tready_from_flush_reg : std_logic;
  signal fifo_flush_done_reg : std_logic;
  signal im_axis_tdata_reg : std_logic_vector(31 downto 0);
  signal fifo_flush_wait_cnt_reg : unsigned(31 downto 0);

  type axis_flush_st_t is (RESET_ST, IDLE_ST, FLUSH_ST, WAIT_ST, DONE_ST);
  signal axis_flush_st_reg : axis_flush_st_t;

begin
  -- I/O Connections assignments

  S_AXI_AWREADY <= axi_awready;
  S_AXI_WREADY <= axi_wready;
  S_AXI_BRESP <= axi_bresp;
  S_AXI_BVALID <= axi_bvalid;
  S_AXI_ARREADY <= axi_arready;
  S_AXI_RDATA <= axi_rdata;
  S_AXI_RRESP <= axi_rresp;
  S_AXI_RVALID <= axi_rvalid;
  -- Implement axi_awready generation
  -- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
  -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
  -- de-asserted when reset is low.

  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        axi_awready <= '0';
        aw_en <= '1';
      else
        if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
          -- slave is ready to accept write address when
          -- there is a valid write address and write data
          -- on the write address and data bus. This design
          -- expects no outstanding transactions.
          axi_awready <= '1';
          aw_en <= '0';
        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
          aw_en <= '1';
          axi_awready <= '0';
        else
          axi_awready <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Implement axi_awaddr latching
  -- This process is used to latch the address when both
  -- S_AXI_AWVALID and S_AXI_WVALID are valid.

  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        axi_awaddr <= (others => '0');
      else
        if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
          -- Write Address latching
          axi_awaddr <= S_AXI_AWADDR;
        end if;
      end if;
    end if;
  end process;

  -- Implement axi_wready generation
  -- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
  -- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is
  -- de-asserted when reset is low.

  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        axi_wready <= '0';
      else
        if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
          -- slave is ready to accept write data when
          -- there is a valid write address and write data
          -- on the write address and data bus. This design
          -- expects no outstanding transactions.
          axi_wready <= '1';
        else
          axi_wready <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Implement memory mapped register select and write logic generation
  -- The write data is accepted and written to memory mapped registers when
  -- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
  -- select byte enables of slave registers while writing.
  -- These registers are cleared when reset (active low) is applied.
  -- Slave register write enable is asserted when valid address and data are available
  -- and the slave is ready to accept the write address and write data.
  slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID;

  process (S_AXI_ACLK)
    variable loc_addr : integer;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        fifo_flush_en_reg <= (others => '0');
        fifo_flush_count_max_reg <= (others => '0');
      else
        loc_addr := to_integer(unsigned(axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB)));
        if (slv_reg_wren = '1') then
          case loc_addr is
            when FIFO_FLUSH_EN_ADDR =>
              for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
                if (S_AXI_WSTRB(byte_index) = '1') then
                  fifo_flush_en_reg(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
                end if;
              end loop;
            when FIFO_FLUSH_COUNT_MAX_ADDR =>
              for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8 - 1) loop
                if (S_AXI_WSTRB(byte_index) = '1') then
                  fifo_flush_count_max_reg(byte_index * 8 + 7 downto byte_index * 8) <= S_AXI_WDATA(byte_index * 8 + 7 downto byte_index * 8);
                end if;
              end loop;
            when others =>
              -- read only or invalid registers
          end case;
        end if;
      end if;
    end if;
  end process;

  -- Implement write response logic generation
  -- The write response and response valid signals are asserted by the slave
  -- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
  -- This marks the acceptance of address and indicates the status of
  -- write transaction.

  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        axi_bvalid <= '0';
        axi_bresp <= "00"; --need to work more on the responses
      else
        if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0') then
          axi_bvalid <= '1';
          axi_bresp <= "00";
        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then --check if bready is asserted while bvalid is high)
          axi_bvalid <= '0'; -- (there is a possibility that bready is always asserted high)
        end if;
      end if;
    end if;
  end process;

  -- Implement axi_arready generation
  -- axi_arready is asserted for one S_AXI_ACLK clock cycle when
  -- S_AXI_ARVALID is asserted. axi_awready is
  -- de-asserted when reset (active low) is asserted.
  -- The read address is also latched when S_AXI_ARVALID is
  -- asserted. axi_araddr is reset to zero on reset assertion.

  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        axi_arready <= '0';
        axi_araddr <= (others => '1');
      else
        if (axi_arready = '0' and S_AXI_ARVALID = '1') then
          -- indicates that the slave has acceped the valid read address
          axi_arready <= '1';
          -- Read Address latching
          axi_araddr <= S_AXI_ARADDR;
        else
          axi_arready <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Implement axi_arvalid generation
  -- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
  -- S_AXI_ARVALID and axi_arready are asserted. The slave registers
  -- data are available on the axi_rdata bus at this instance. The
  -- assertion of axi_rvalid marks the validity of read data on the
  -- bus and axi_rresp indicates the status of read transaction.axi_rvalid
  -- is deasserted on reset (active low). axi_rresp and axi_rdata are
  -- cleared to zero on reset (active low).
  process (S_AXI_ACLK)
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        axi_rvalid <= '0';
        axi_rresp <= "00";
      else
        if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
          -- Valid read data is available at the read data bus
          axi_rvalid <= '1';
          axi_rresp <= "00"; -- 'OKAY' response
        elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
          -- Read data is accepted by the master
          axi_rvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Implement memory mapped register select and read logic generation
  -- Slave register read enable is asserted when valid address is available
  -- and the slave is ready to accept the read address.
  slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid);

  -- Output register or memory read data
  process (S_AXI_ACLK) is
    variable loc_addr : integer;
  begin
    if (rising_edge (S_AXI_ACLK)) then
      if (S_AXI_ARESETN = '0') then
        axis_tready_from_axi_reg <= '0';
        axi_rdata <= (others => '0');
      else
        loc_addr := to_integer(unsigned(axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB)));
        axis_tready_from_axi_reg <= '0';
        -- When there is a valid read address (S_AXI_ARVALID) with
        -- acceptance of read address by the slave (axi_arready),
        -- output the read dada
        -- Read address mux
        if (slv_reg_rden = '1') then
          case loc_addr is
            when CORE_ID_ADDR =>
              axi_rdata <= CORE_ID;
            when FIFO_FULL_ADDR =>
              axi_rdata <= (others => '0');
              axi_rdata(0) <= fifo_full_in;
            when FIFO_FLUSH_EN_ADDR =>
              axi_rdata <= (others => '0');
              axi_rdata(0) <= fifo_flush_en_reg(0);
            when FIFO_FLUSH_COUNT_MAX_ADDR =>
              axi_rdata <= fifo_flush_count_max_reg;
            when FIFO_FLUSH_DONE_ADDR =>
              axi_rdata <= (others => '0');
              axi_rdata(0) <= fifo_flush_done_reg;
            when FIFO_DATA_RE_ADDR =>
              -- accept a new data only when it's available from the AXI-S master
              if (s_axis_tvalid = '1') then
                axis_tready_from_axi_reg <= '1';
                im_axis_tdata_reg <= s_axis_tdata(63 downto 32);
                axi_rdata <= s_axis_tdata(31 downto 0);
              else
                axi_rdata <= READ_ERROR;
              end if;
            when FIFO_DATA_IM_ADDR =>
              -- IM data should only be read after real
              axi_rdata <= im_axis_tdata_reg;
            when others =>
              axi_rdata <= READ_ERROR;
          end case;

        end if;
      end if;
    end if;
  end process;

  process (S_AXI_ACLK) is
  begin
    if (rising_edge (S_AXI_ACLK)) then
      if (S_AXI_ARESETN = '0') then
        axis_tready_from_flush_reg <= '0';
        fifo_flush_wait_cnt_reg <= (others => '0');
        axis_flush_st_reg <= RESET_ST;
        fifo_flush_done_reg <= '0';
      else
        axis_tready_from_flush_reg <= '0';
        fifo_flush_done_reg <= '0';
        case axis_flush_st_reg is
          when RESET_ST =>
            axis_flush_st_reg <= IDLE_ST;
          when IDLE_ST =>
            if (fifo_flush_en_reg(0) = '1') then
              axis_flush_st_reg <= FLUSH_ST;
            end if;
          when FLUSH_ST =>
            fifo_flush_wait_cnt_reg <= (others => '0');
            if (fifo_flush_en_reg(0) = '0') then
              axis_flush_st_reg <= IDLE_ST;
            else
              if (s_axis_tvalid = '1') then
                axis_tready_from_flush_reg <= '1';
              else
                axis_flush_st_reg <= WAIT_ST;
              end if;
            end if;
          when WAIT_ST =>
            if (fifo_flush_en_reg(0) = '0') then
              axis_flush_st_reg <= IDLE_ST;
            else
              if (s_axis_tvalid = '0') then
                if (fifo_flush_wait_cnt_reg > unsigned(fifo_flush_count_max_reg)) then
                  axis_flush_st_reg <= DONE_ST;
                else
                  fifo_flush_wait_cnt_reg <= fifo_flush_wait_cnt_reg + 1;
                end if;
              else
                axis_flush_st_reg <= FLUSH_ST;
              end if;
            end if;
          when DONE_ST =>
            fifo_flush_done_reg <= '1';
            if (fifo_flush_en_reg(0) = '0') then
              axis_flush_st_reg <= IDLE_ST;
            end if;
          when others =>
            axis_flush_st_reg <= IDLE_ST;
        end case;
      end if;
    end if;
  end process;

  s_axis_tready <= axis_tready_from_flush_reg or axis_tready_from_axi_reg;

end arch_imp;
